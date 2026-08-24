# ==============================================================================
# CÁC TRUY VẤN MẪU (CYPHER QUERY EXAMPLES) - KNOWLEDGE GRAPH TIỂU ĐƯỜNG
# Nguồn: Nhà Thuốc Long Châu (nhathuoclongchau.com.vn)
# ==============================================================================

import sys
if sys.stdout.encoding.lower() != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

QUERIES = {
    "1. Tìm các biến chứng nguy hiểm nhất của Đái tháo đường Type 2": """
        MATCH (d:Disease {name: "Đái tháo đường Type 2"})-[r:CAUSES_COMPLICATION]->(c:Complication)
        RETURN d.name AS Benh, c.name AS BienChung, c.organ AS CoQuan, c.type AS LoaiMachMau, r.timeframe AS ThoiGianPhatTrien
        ORDER BY c.organ
    """,

    "2. Tra cứu phác đồ thuốc điều trị và biệt dược Nhà Thuốc Long Châu": """
        MATCH (d:Disease)-[r:TREATED_WITH]->(m:Medication)
        RETURN d.name AS Benh, m.name AS TenThuoc, m.drug_class AS NhomThuoc, r.line AS ThuTuUuTien, m.common_brand AS BietDuocLongChau
    """,

    "3. Tư vấn dinh dưỡng và vận động cho bệnh nhân Tiền đái tháo đường": """
        MATCH (d:Disease {id: "DIS_PRE"})-[r:MANAGED_BY]->(l:LifestyleDiet)
        RETURN d.name AS TinhTrang, l.name AS KhuyenNghi, l.type AS Loai, l.priority AS DoUuTien
    """,

    "4. Phân tích các yếu tố nguy cơ có thể can thiệp được (Modifiable Risk Factors)": """
        MATCH (d:Disease)-[:HAS_RISK_FACTOR]->(r:RiskFactor {modifiable: true})
        OPTIONAL MATCH (r)-[:MEASURED_BY]->(m:ClinicalMetric)
        RETURN DISTINCT r.name AS YeuToNguyCo, r.category AS PhanLoai, m.name AS ChiSoDoLuong, m.normal_range AS NguongBinhThuong
    """
}

if __name__ == "__main__":
    print("=== DANH SÁCH TRUY VẤN MẪU CYPHER CHO TIỂU ĐƯỜNG (LONG CHÂU) ===\n")
    for title, q in QUERIES.items():
        print(f"🔹 {title}:")
        print(q.strip())
        print("-" * 75)
