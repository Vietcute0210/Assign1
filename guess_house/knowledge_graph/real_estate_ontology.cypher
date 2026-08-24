// ==============================================================================
// KNOWLEDGE GRAPH: ĐỊNH GIÁ & THỊ TRƯỜNG BẤT ĐỘNG SẢN VIỆT NAM
// Nguồn tri thức: Cấu trúc phân loại & Tiêu chí thẩm định Batdongsan.com.vn
// Ngôn ngữ: Cypher (Neo4j Graph Database)
// ==============================================================================

// ------------------------------------------------------------------------------
// 1. TẠO RÀNG BUỘC DUY NHẤT (CONSTRAINTS)
// ------------------------------------------------------------------------------
CREATE CONSTRAINT unique_prop_type IF NOT EXISTS FOR (pt:PropertyType) REQUIRE pt.id IS UNIQUE;
CREATE CONSTRAINT unique_province IF NOT EXISTS FOR (p:Province) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT unique_district IF NOT EXISTS FOR (d:District) REQUIRE d.id IS UNIQUE;
CREATE CONSTRAINT unique_legal IF NOT EXISTS FOR (l:LegalStatus) REQUIRE l.id IS UNIQUE;
CREATE CONSTRAINT unique_amenity IF NOT EXISTS FOR (a:Amenity) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT unique_factor IF NOT EXISTS FOR (f:ValuationFactor) REQUIRE f.id IS UNIQUE;
CREATE CONSTRAINT unique_segment IF NOT EXISTS FOR (s:PriceSegment) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT unique_direction IF NOT EXISTS FOR (dir:HouseDirection) REQUIRE dir.id IS UNIQUE;

// ------------------------------------------------------------------------------
// 2. TẠO CÁC NỐT THỰC THỂ (NODES)
// ------------------------------------------------------------------------------

// [NODES: LOẠI HÌNH BẤT ĐỘNG SẢN - PropertyType]
MERGE (pt_house:PropertyType {id: "PT_HOUSE", name: "Nhà riêng / Nhà thổ cư", liquidity: "Rất cao", risk: "Thấp", source: "Batdongsan.com.vn"});
MERGE (pt_townhouse:PropertyType {id: "PT_TOWNHOUSE", name: "Nhà mặt phố / Nhà phố kinh doanh", liquidity: "Cao", risk: "Thấp", business_potential: "Tối ưu"});
MERGE (pt_villa:PropertyType {id: "PT_VILLA", name: "Biệt thự / Liền kề dự án", liquidity: "Trung bình", segment: "Thượng lưu", space: "Rộng rãi"});
MERGE (pt_apt:PropertyType {id: "PT_APT", name: "Căn hộ chung cư", liquidity: "Rất cao", depreciation_risk: "Trung bình"});
MERGE (pt_land:PropertyType {id: "PT_LAND", name: "Đất nền thổ cư", liquidity: "Biến động", growth_potential: "Rất cao"});

// [NODES: ĐỊA GIỚI HÀNH CHÍNH - Province & District]
MERGE (p_hn:Province {id: "PROV_HN", name: "Hà Nội", region: "Miền Bắc", market_tier: "Đô thị loại đặc biệt"});
MERGE (p_hcm:Province {id: "PROV_HCM", name: "Hồ Chí Minh", region: "Miền Nam", market_tier: "Đô thị loại đặc biệt"});
MERGE (p_dn:Province {id: "PROV_DN", name: "Đà Nẵng", region: "Miền Trung", market_tier: "Đô thị loại 1"});

// Quận/Huyện Hà Nội
MERGE (d_cg:District {id: "DIST_CG", name: "Quận Cầu Giấy", avg_price_m2: 165.0, status: "Trung tâm dịch vụ & Công nghệ", province: "Hà Nội"});
MERGE (d_hk:District {id: "DIST_HK", name: "Quận Hoàn Kiếm", avg_price_m2: 450.0, status: "Trung tâm văn hóa lịch sử lõi", province: "Hà Nội"});
MERGE (d_ntl:District {id: "DIST_NTL", name: "Quận Nam Từ Liêm", avg_price_m2: 120.0, status: "Trung tâm hành chính mới", province: "Hà Nội"});
MERGE (d_dd:District {id: "DIST_DD", name: "Quận Đống Đa", avg_price_m2: 180.0, status: "Quận nội thành lõi", province: "Hà Nội"});
MERGE (d_tx:District {id: "DIST_TX", name: "Quận Thanh Xuân", avg_price_m2: 140.0, status: "Đô thị hóa cao", province: "Hà Nội"});

// Quận/Huyện TP. Hồ Chí Minh
MERGE (d_q1:District {id: "DIST_Q1", name: "Quận 1", avg_price_m2: 500.0, status: "Lõi trung tâm tài chính", province: "Hồ Chí Minh"});
MERGE (d_thuduc:District {id: "DIST_THUDUC", name: "TP. Thủ Đức", avg_price_m2: 110.0, status: "Đô thị sáng tạo phía Đông", province: "Hồ Chí Minh"});
MERGE (d_bt:District {id: "DIST_BT", name: "Quận Bình Thạnh", avg_price_m2: 170.0, status: "Cửa ngõ trung tâm", province: "Hồ Chí Minh"});

// [NODES: TÌNH TRẠNG PHÁP LÝ - LegalStatus]
MERGE (l_red:LegalStatus {id: "LEG_RED", name: "Sổ đỏ / Sổ hồng riêng (Đã hoàn công)", safety_score: 10, bank_loan_eligible: true, valuation_multiplier: 1.0});
MERGE (l_contract:LegalStatus {id: "LEG_CONTRACT", name: "Hợp đồng mua bán chủ đầu tư (HĐMB)", safety_score: 8, bank_loan_eligible: true, valuation_multiplier: 0.95});
MERGE (l_waiting:LegalStatus {id: "LEG_WAITING", name: "Đang chờ cấp sổ (Biên nhận)", safety_score: 6, bank_loan_eligible: false, valuation_multiplier: 0.85});
MERGE (l_hand:LegalStatus {id: "LEG_HAND", name: "Giấy tờ viết tay / Vi bằng", safety_score: 3, bank_loan_eligible: false, valuation_multiplier: 0.65});

// [NODES: TIỆN ÍCH NGOẠI KHU XUNG QUANH - Amenity]
MERGE (a_metro:Amenity {id: "AMN_METRO", name: "Gần Ga Tàu điện / Tuyến Metro", price_premium_pct: 15, radius_m: 800});
MERGE (a_hospital:Amenity {id: "AMN_HOSP", name: "Gần Bệnh viện tuyến Trung ương", price_premium_pct: 8, radius_m: 1500});
MERGE (a_university:Amenity {id: "AMN_UNI", name: "Gần Cụm các trường Đại học lớn", rental_demand: "Rất cao", price_premium_pct: 10});
MERGE (a_mall:Amenity {id: "AMN_MALL", name: "Gần TTTM Aeon Mall / Vincom", price_premium_pct: 7, radius_m: 1000});
MERGE (a_park:Amenity {id: "AMN_PARK", name: "Gần Công viên / Hồ điều hòa", living_quality: "Tuyệt hảo", price_premium_pct: 12});

// [NODES: CÁC YẾU TỐ ĐỊNH GIÁ & ĐẶC TRƯNG - ValuationFactor]
MERGE (f_area:ValuationFactor {id: "FAC_AREA", name: "Diện tích sử dụng (Area m²)", impact: "Cốt lõi quyết định tổng giá trị", unit: "m²"});
MERGE (f_frontage:ValuationFactor {id: "FAC_FRONTAGE", name: "Mặt tiền rộng (Frontage >= 4.5m)", impact: "Tăng tính thanh khoản và khả năng kinh doanh"});
MERGE (f_car_alley:ValuationFactor {id: "FAC_CAR_ALLEY", name: "Ngõ ô tô tránh nhau (Access Road >= 4m)", impact: "Tăng 20-30% đơn giá so với ngõ xe máy"});
MERGE (f_floors:ValuationFactor {id: "FAC_FLOORS", name: "Số tầng xây dựng kiên cố (Floors)", impact: "Tăng tổng diện tích sàn sử dụng"});
MERGE (f_bedrooms:ValuationFactor {id: "FAC_BEDROOMS", name: "Số phòng ngủ (Bedrooms)", impact: "Phù hợp nhu cầu gia đình hoặc cho thuê dòng tiền"});

// [NODES: HƯỚNG NHÀ - HouseDirection]
MERGE (dir_se:HouseDirection {id: "DIR_SE", name: "Đông Nam", fengshui_rating: "Đón gió mát, được ưa chuộng nhất tại VN", demand: "Rất cao"});
MERGE (dir_s:HouseDirection {id: "DIR_S", name: "Chính Nam", fengshui_rating: "Ấm mùa đông, mát mùa hè", demand: "Cao"});
MERGE (dir_w:HouseDirection {id: "DIR_W", name: "Chính Tây", fengshui_rating: "Nắng gắt buổi chiều, cần giải pháp cách nhiệt", demand: "Thấp hơn"});
MERGE (dir_e:HouseDirection {id: "DIR_E", name: "Chính Đông", fengshui_rating: "Đón bình minh, phong thủy thịnh vượng", demand: "Cao"});

// [NODES: PHÂN KHÚC GIÁ THỊ TRƯỜNG - PriceSegment]
MERGE (seg_budget:PriceSegment {id: "SEG_BUDGET", name: "Phân khúc Bình dân / Giá rẻ", price_range: "< 3.0 Tỷ VNĐ", target_buyer: "Người độc thân, gia đình trẻ mua nhà lần đầu"});
MERGE (seg_mid:PriceSegment {id: "SEG_MID", name: "Phân khúc Trung cấp (Phổ thông)", price_range: "3.0 - 7.0 Tỷ VNĐ", target_buyer: "Gia đình tiêu chuẩn 2-3 thế hệ"});
MERGE (seg_high:PriceSegment {id: "SEG_HIGH", name: "Phân khúc Cao cấp", price_range: "7.0 - 15.0 Tỷ VNĐ", target_buyer: "Khách hàng thu nhập cao, nhà đầu tư sinh lời"});
MERGE (seg_luxury:PriceSegment {id: "SEG_LUXURY", name: "Phân khúc Siêu sang / Biệt lập", price_range: "> 15.0 Tỷ VNĐ", target_buyer: "Tầng lớp thượng lưu, biệt thự phố cổ"});


// ------------------------------------------------------------------------------
// 3. TẠO CÁC MỐI QUAN HỆ (RELATIONSHIPS)
// ------------------------------------------------------------------------------

// Địa giới: Quận -> Tỉnh
MERGE (d_cg)-[:BELONGS_TO_PROVINCE]->(p_hn);
MERGE (d_hk)-[:BELONGS_TO_PROVINCE]->(p_hn);
MERGE (d_ntl)-[:BELONGS_TO_PROVINCE]->(p_hn);
MERGE (d_dd)-[:BELONGS_TO_PROVINCE]->(p_hn);
MERGE (d_tx)-[:BELONGS_TO_PROVINCE]->(p_hn);

MERGE (d_q1)-[:BELONGS_TO_PROVINCE]->(p_hcm);
MERGE (d_thuduc)-[:BELONGS_TO_PROVINCE]->(p_hcm);
MERGE (d_bt)-[:BELONGS_TO_PROVINCE]->(p_hcm);

// Loại hình BĐS -> Pháp lý phổ biến
MERGE (pt_house)-[:COMMONLY_HAS_LEGAL]->(l_red);
MERGE (pt_townhouse)-[:COMMONLY_HAS_LEGAL]->(l_red);
MERGE (pt_apt)-[:COMMONLY_HAS_LEGAL]->(l_contract);
MERGE (pt_apt)-[:COMMONLY_HAS_LEGAL]->(l_red);

// Loại hình BĐS -> Phân khúc giá điển hình
MERGE (pt_townhouse)-[:TYPICAL_PRICE_SEGMENT]->(seg_high);
MERGE (pt_townhouse)-[:TYPICAL_PRICE_SEGMENT]->(seg_luxury);
MERGE (pt_house)-[:TYPICAL_PRICE_SEGMENT]->(seg_mid);
MERGE (pt_house)-[:TYPICAL_PRICE_SEGMENT]->(seg_high);
MERGE (pt_apt)-[:TYPICAL_PRICE_SEGMENT]->(seg_budget);
MERGE (pt_apt)-[:TYPICAL_PRICE_SEGMENT]->(seg_mid);

// Quận huyện -> Tiện ích nổi bật & Phân khúc thị trường
MERGE (d_cg)-[:HAS_NOTABLE_AMENITY]->(a_university);
MERGE (d_cg)-[:HAS_NOTABLE_AMENITY]->(a_metro);
MERGE (d_cg)-[:HAS_NOTABLE_AMENITY]->(a_park);
MERGE (d_cg)-[:DOMINANT_SEGMENT]->(seg_mid);
MERGE (d_cg)-[:DOMINANT_SEGMENT]->(seg_high);

MERGE (d_hk)-[:DOMINANT_SEGMENT]->(seg_luxury);
MERGE (d_q1)-[:DOMINANT_SEGMENT]->(seg_luxury);
MERGE (d_ntl)-[:HAS_NOTABLE_AMENITY]->(a_metro);
MERGE (d_ntl)-[:DOMINANT_SEGMENT]->(seg_mid);

// Yếu tố định giá -> Tác động đơn giá
MERGE (f_car_alley)-[:BOOSTS_PRICE_BY {pct: "20% - 30%"}]->(pt_house);
MERGE (f_frontage)-[:BOOSTS_PRICE_BY {pct: "15% - 25%"}]->(pt_townhouse);
MERGE (a_metro)-[:APPRECIATES_VALUE {annual_growth: "10% - 15%"}]->(pt_apt);
MERGE (a_metro)-[:APPRECIATES_VALUE]->(pt_house);

// Hướng nhà -> Mức độ thanh khoản
MERGE (dir_se)-[:FAVORED_IN]->(pt_house);
MERGE (dir_s)-[:FAVORED_IN]->(pt_house);\n