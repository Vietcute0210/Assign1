import streamlit as st
import pandas as pd
import numpy as np
import joblib
import os
from datetime import datetime

# Cấu hình trang chuẩn Mobile
st.set_page_config(
    page_title="Chẩn Đoán Tiểu Đường AI",
    page_icon="🩺",
    layout="centered",
    initial_sidebar_state="collapsed"
)

# CSS tối ưu trải nghiệm trên Smartphone
st.markdown("""
<style>
    .main-title {
        font-size: 24px;
        font-weight: bold;
        text-align: center;
        color: #047857;
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
        background-color: #F9FAFB;
    }
    .stButton>button {
        width: 100%;
        background: linear-gradient(90deg, #059669, #047857);
        color: white;
        font-size: 18px;
        font-weight: bold;
        height: 52px;
        border-radius: 12px;
        border: none;
        box-shadow: 0 4px 6px -1px rgba(5, 150, 105, 0.2);
    }
    .result-safe {
        background: #ECFDF5;
        border: 2px solid #10B981;
        border-radius: 12px;
        padding: 18px;
        text-align: center;
        margin-top: 18px;
    }
    .result-danger {
        background: #FEF2F2;
        border: 2px solid #EF4444;
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

st.markdown('<div class="main-title">🩺 Chẩn Đoán Tiểu Đường AI</div>', unsafe_allow_html=True)
st.markdown('<div class="sub-title">Ứng dụng AI Hỗ Trợ Sàng Lọc Sức Khỏe Trên Mobile</div>', unsafe_allow_html=True)

if 'history' not in st.session_state:
    st.session_state['history'] = []
if 'latest_result' not in st.session_state:
    st.session_state['latest_result'] = None

@st.cache_resource
def load_resources():
    if not os.path.exists('best_diabetes_model.pkl') or not os.path.exists('diabetes_scaler.pkl'):
        return None, None, None
    model = joblib.load('best_diabetes_model.pkl')
    scaler = joblib.load('diabetes_scaler.pkl')
    metadata = joblib.load('diabetes_metadata.pkl')
    return model, scaler, metadata

model, scaler, metadata = load_resources()

if model is None:
    st.error("⚠️ Chưa tìm thấy file best_diabetes_model.pkl! Hãy chạy các cell trong notebook trước.")
else:
    with st.form(key="diabetes_form", clear_on_submit=False):
        st.markdown("##### 📋 1. Chỉ số Đường huyết & Huyết áp")
        col1, col2 = st.columns(2)
        with col1:
            glucose = st.number_input("Đường huyết Glucose (mg/dL):", min_value=40.0, max_value=300.0, value=120.0, step=1.0)
            blood_pressure = st.number_input("Huyết áp tâm trương (mm Hg):", min_value=30.0, max_value=200.0, value=70.0, step=1.0)
        with col2:
            insulin = st.number_input("Nồng độ Insulin (mu U/ml):", min_value=5.0, max_value=900.0, value=125.0, step=5.0)
            skin_thickness = st.number_input("Độ dày nếp gấp da (mm):", min_value=5.0, max_value=100.0, value=25.0, step=1.0)

        st.markdown("##### 👤 2. Thể trạng & Tiền sử")
        col3, col4 = st.columns(2)
        with col3:
            bmi = st.number_input("Chỉ số khối cơ thể BMI:", min_value=10.0, max_value=70.0, value=26.5, step=0.5)
            age = st.number_input("Tuổi:", min_value=1, max_value=120, value=35, step=1)
        with col4:
            pregnancies = st.number_input("Số lần mang thai:", min_value=0, max_value=20, value=1, step=1)
            dpf = st.number_input("Chỉ số di truyền DPF:", min_value=0.05, max_value=3.0, value=0.45, step=0.05)

        st.markdown("<br>", unsafe_allow_html=True)
        submit_btn = st.form_submit_button("🩺 CHẨN ĐOÁN NGUY CƠ NGAY")

    if submit_btn:
        input_raw = np.array([[pregnancies, glucose, blood_pressure, skin_thickness, insulin, bmi, dpf, age]])
        input_scaled = scaler.transform(input_raw)

        pred_label = int(model.predict(input_scaled)[0])
        if hasattr(model, "predict_proba"):
            pred_prob = float(model.predict_proba(input_scaled)[0][1]) * 100
        else:
            pred_prob = 100.0 if pred_label == 1 else 0.0

        st.session_state['latest_result'] = {
            'label': pred_label,
            'prob': pred_prob,
            'glucose': glucose,
            'bmi': bmi,
            'age': age,
            'model_name': metadata['best_model_name'],
            'time': datetime.now().strftime("%H:%M:%S")
        }
        st.session_state['history'].insert(0, st.session_state['latest_result'])
        if len(st.session_state['history']) > 5:
            st.session_state['history'].pop()

    if st.session_state['latest_result'] is not None:
        res = st.session_state['latest_result']
        if res['label'] == 1:
            st.markdown(f"""
            <div class="result-danger">
                <div style="font-size: 16px; color: #991B1B; font-weight: bold;">⚠️ KẾT QUẢ: CẢNH BÁO NGUY CƠ TIỂU ĐƯỜNG</div>
                <div style="font-size: 32px; font-weight: bold; color: #DC2626; margin: 8px 0;">
                    Xác suất: {res['prob']:.1f}%
                </div>
                <div style="font-size: 13px; color: #4B5563;">
                    (Chỉ số Glucose: <b>{res['glucose']} mg/dL</b> | BMI: <b>{res['bmi']}</b> | Tuổi: <b>{int(res['age'])}</b>)
                </div>
                <div style="margin-top: 8px; font-size: 12px; color: #6B7280;">
                    Khuyến nghị: Người dùng nên đến cơ sở y tế gần nhất để xét nghiệm chuyên sâu.
                </div>
            </div>
            """, unsafe_allow_html=True)
        else:
            st.markdown(f"""
            <div class="result-safe">
                <div style="font-size: 16px; color: #065F46; font-weight: bold;">✅ KẾT QUẢ: NGUY CƠ THẤP (BÌNH THƯỜNG)</div>
                <div style="font-size: 32px; font-weight: bold; color: #059669; margin: 8px 0;">
                    Xác suất bệnh: {res['prob']:.1f}%
                </div>
                <div style="font-size: 13px; color: #4B5563;">
                    (Chỉ số Glucose: <b>{res['glucose']} mg/dL</b> | BMI: <b>{res['bmi']}</b> | Tuổi: <b>{int(res['age'])}</b>)
                </div>
                <div style="margin-top: 8px; font-size: 12px; color: #065F46;">
                    Đánh giá: Các chỉ số hiện tại nằm trong ngưỡng an toàn.
                </div>
            </div>
            """, unsafe_allow_html=True)

        if len(st.session_state['history']) > 1:
            st.markdown("<br><b>🕒 Lịch sử chẩn đoán vừa qua:</b>", unsafe_allow_html=True)
            for idx, h in enumerate(st.session_state['history']):
                tag = "<span style='color:#DC2626;font-weight:bold;'>⚠️ Có nguy cơ</span>" if h['label']==1 else "<span style='color:#059669;font-weight:bold;'>✅ Bình thường</span>"
                st.markdown(f"""
                <div class="history-card">
                    <b>#{len(st.session_state['history']) - idx}</b>. Glucose: {h['glucose']} | BMI: {h['bmi']} | Tuổi: {int(h['age'])} ➔ {tag} ({h['prob']:.1f}%)
                </div>
                """, unsafe_allow_html=True)
