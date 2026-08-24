import streamlit as st
import pandas as pd
import numpy as np
import joblib
import os
from datetime import datetime

# Cấu hình giao diện di động
st.set_page_config(
    page_title="Dự Đoán Giá Nhà VN",
    page_icon="🏠",
    layout="centered",
    initial_sidebar_state="collapsed"
)

# CSS tùy biến tối ưu trên Smartphone
st.markdown("""
<style>
    .main-title {
        font-size: 24px;
        font-weight: bold;
        text-align: center;
        color: #1E3A8A;
        margin-bottom: 2px;
    }
    .sub-title {
        font-size: 13px;
        text-align: center;
        color: #6B7280;
        margin-bottom: 16px;
    }
    div[data-testid="stForm"] {
        border: 1px solid #E5E7EB;
        border-radius: 12px;
        padding: 16px;
        background-color: #FAFAFA;
    }
    .stButton>button {
        width: 100%;
        background: linear-gradient(90deg, #2563EB, #1D4ED8);
        color: white;
        font-size: 18px;
        font-weight: bold;
        height: 52px;
        border-radius: 12px;
        border: none;
        box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
        transition: all 0.2s ease;
    }
    .stButton>button:hover {
        background: linear-gradient(90deg, #1D4ED8, #1E40AF);
        box-shadow: 0 6px 8px -1px rgba(37, 99, 235, 0.3);
    }
    .result-box {
        background: #EFF6FF;
        border: 2px solid #3B82F6;
        border-radius: 12px;
        padding: 18px;
        text-align: center;
        margin-top: 18px;
    }
    .history-card {
        background: #FFFFFF;
        border: 1px solid #E5E7EB;
        border-radius: 8px;
        padding: 10px 14px;
        margin-bottom: 8px;
        font-size: 13px;
    }
</style>
""", unsafe_allow_html=True)

st.markdown('<div class="main-title">🏠 Dự Đoán Giá Nhà VN</div>', unsafe_allow_html=True)
st.markdown('<div class="sub-title">Ứng dụng AI định giá Bất Động Sản trên Mobile</div>', unsafe_allow_html=True)

# Khởi tạo session_state để lưu trữ kết quả và lịch sử dự đoán
if 'history' not in st.session_state:
    st.session_state['history'] = []
if 'latest_result' not in st.session_state:
    st.session_state['latest_result'] = None

# Load mô hình và metadata
@st.cache_resource
def load_resources():
    if not os.path.exists('best_model.pkl') or not os.path.exists('model_metadata.pkl'):
        return None, None
    model = joblib.load('best_model.pkl')
    metadata = joblib.load('model_metadata.pkl')
    return model, metadata

model, metadata = load_resources()

if model is None:
    st.error("⚠️ Chưa tìm thấy file best_model.pkl! Hãy đảm bảo đã huấn luyện mô hình trước.")
else:
    encoders = metadata['encoders']

    # Form nhập liệu
    with st.form(key="house_price_form", clear_on_submit=False):
        st.markdown("##### 📍 1. Vị trí & Pháp lý")
        city_options = list(encoders['City'].classes_)
        selected_city = st.selectbox("Thành phố / Tỉnh:", city_options, index=0)

        legal_options = list(encoders['Legal status'].classes_)
        selected_legal = st.selectbox("Tình trạng pháp lý:", legal_options, index=0)

        st.markdown("##### 📐 2. Kích thước & Quy mô")
        col1, col2 = st.columns(2)
        with col1:
            area = st.number_input("Diện tích (m²):", min_value=10.0, max_value=800.0, value=65.0, step=5.0)
            floors = st.number_input("Số tầng:", min_value=1, max_value=15, value=3, step=1)
            bedrooms = st.number_input("Phòng ngủ:", min_value=1, max_value=15, value=3, step=1)
        with col2:
            frontage = st.number_input("Mặt tiền (m):", min_value=1.0, max_value=50.0, value=4.5, step=0.5)
            access_road = st.number_input("Đường vào (m):", min_value=1.0, max_value=50.0, value=5.0, step=0.5)
            bathrooms = st.number_input("Phòng tắm:", min_value=1, max_value=15, value=3, step=1)

        st.markdown("##### 🧭 3. Hướng & Nội thất")
        direction_options = list(encoders['House direction'].classes_)
        selected_direction = st.selectbox("Hướng nhà:", direction_options, index=0)

        balcony_options = list(encoders['Balcony direction'].classes_)
        selected_balcony = st.selectbox("Hướng ban công:", balcony_options, index=0)

        furn_options = list(encoders['Furniture state'].classes_)
        selected_furn = st.selectbox("Tình trạng nội thất:", furn_options, index=0)

        st.markdown("<br>", unsafe_allow_html=True)
        submit_btn = st.form_submit_button("🎯 DỰ ĐOÁN GIÁ NGAY")

    # Xử lý dự đoán
    if submit_btn:
        input_dict = {
            'Area': float(area),
            'Frontage': float(frontage),
            'Access Road': float(access_road),
            'Floors': float(floors),
            'Bedrooms': float(bedrooms),
            'Bathrooms': float(bathrooms),
            'House direction_encoded': encoders['House direction'].transform([selected_direction])[0],
            'Balcony direction_encoded': encoders['Balcony direction'].transform([selected_balcony])[0],
            'Legal status_encoded': encoders['Legal status'].transform([selected_legal])[0],
            'Furniture state_encoded': encoders['Furniture state'].transform([selected_furn])[0],
            'City_encoded': encoders['City'].transform([selected_city])[0]
        }

        input_df = pd.DataFrame([input_dict])
        input_df = input_df[metadata['feature_cols']]

        predicted_price = float(model.predict(input_df)[0])
        predicted_price = max(0.1, predicted_price)
        price_per_m2 = (predicted_price * 1000) / float(area)

        st.session_state['latest_result'] = {
            'price': predicted_price,
            'price_per_m2': price_per_m2,
            'city': selected_city,
            'area': area,
            'floors': floors,
            'bedrooms': bedrooms,
            'bathrooms': bathrooms,
            'model_name': metadata.get('best_model_name', 'Random Forest Regressor'),
            'time': datetime.now().strftime("%H:%M:%S")
        }

        st.session_state['history'].insert(0, st.session_state['latest_result'])
        if len(st.session_state['history']) > 5:
            st.session_state['history'].pop()

    # Hiển thị kết quả
    if st.session_state['latest_result'] is not None:
        res = st.session_state['latest_result']
        st.markdown(f"""
        <div class="result-box">
            <div style="font-size: 15px; color: #4B5563; font-weight: 500;">
                🏷️ Kết quả dự đoán ({res['city']} - {res['area']}m²):
            </div>
            <div style="font-size: 34px; font-weight: bold; color: #1D4ED8; margin: 6px 0;">
                {res['price']:.2f} Tỷ VNĐ
            </div>
            <div style="font-size: 14px; color: #4B5563;">
                Đơn giá: <b>~{res['price_per_m2']:.1f} triệu VNĐ / m²</b>
            </div>
            <div style="margin-top: 10px; font-size: 12px; color: #059669; font-weight: 500;">
                ✨ Thuật toán: {res['model_name']} | Cập nhật: {res['time']}
            </div>
        </div>
        """, unsafe_allow_html=True)

        if len(st.session_state['history']) > 1:
            st.markdown("<br><b>🕒 Lịch sử các lần dự đoán vừa qua:</b>", unsafe_allow_html=True)
            for idx, h in enumerate(st.session_state['history']):
                st.markdown(f"""
                <div class="history-card">
                    <b>#{len(st.session_state['history']) - idx}. {h['city']}</b> | DT: <b>{h['area']}m²</b> | {int(h['floors'])} tầng, {int(h['bedrooms'])}PN 
                    ➔ <span style="color:#1D4ED8; font-weight:bold; font-size:14px;">{h['price']:.2f} Tỷ</span> (~{h['price_per_m2']:.1f} tr/m²)
                </div>
                """, unsafe_allow_html=True)
