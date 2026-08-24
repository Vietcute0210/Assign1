# ==============================================================================
# CÁC TRUY VẤN MẪU (CYPHER QUERY EXAMPLES) - KNOWLEDGE GRAPH BẤT ĐỘNG SẢN
# Nguồn: Batdongsan.com.vn
# ==============================================================================

import sys
if sys.stdout.encoding.lower() != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

QUERIES = {
    "1. Tìm các quận tại Hà Nội có phân khúc giá tầm trung (3 - 7 tỷ) và gần Tuyến Metro": """
        MATCH (p:Province {name: "Hà Nội"})<-[:BELONGS_TO_PROVINCE]-(d:District)-[:DOMINANT_SEGMENT]->(s:PriceSegment {id: "SEG_MID"})
        OPTIONAL MATCH (d)-[:HAS_NOTABLE_AMENITY]->(a:Amenity {id: "AMN_METRO"})
        RETURN d.name AS Quan, d.avg_price_m2 AS DonGiaTB_TrieuM2, s.name AS PhanKhuc, a.name AS TienIch
    """,

    "2. Tra cứu hệ số an toàn và khả năng vay vốn ngân hàng theo Tình trạng pháp lý": """
        MATCH (l:LegalStatus)
        RETURN l.name AS PhapLy, l.safety_score AS DiemAnToan_Tren10, l.bank_loan_eligible AS ChoVayNganHang, l.valuation_multiplier AS HeSoDinhGia
        ORDER BY l.safety_score DESC
    """,

    "3. Phân tích các yếu tố làm gia tăng mạnh giá trị của Nhà riêng (Private House)": """
        MATCH (pt:PropertyType {id: "PT_HOUSE"})<-[r:BOOSTS_PRICE_BY]-(f:ValuationFactor)
        RETURN pt.name AS LoaiBDS, f.name AS YeuToDinhGia, r.pct AS TyLeTangGia, f.impact AS GiaiThich
    """,

    "4. Thống kê mức giá trung bình theo từng quận và phân khúc thống trị": """
        MATCH (d:District)-[:DOMINANT_SEGMENT]->(s:PriceSegment)
        MATCH (d)-[:BELONGS_TO_PROVINCE]->(p:Province)
        RETURN p.name AS TinhThanh, d.name AS Quan, d.avg_price_m2 AS DonGiaTB_tr_m2, s.name AS PhanKhuc
        ORDER BY p.name, d.avg_price_m2 DESC
    """
}

if __name__ == "__main__":
    print("=== DANH SÁCH TRUY VẤN MẪU CYPHER CHO BẤT ĐỘNG SẢN (BATDONGSAN.COM.VN) ===\n")
    for title, q in QUERIES.items():
        print(f"🔹 {title}:")
        print(q.strip())
        print("-" * 75)
