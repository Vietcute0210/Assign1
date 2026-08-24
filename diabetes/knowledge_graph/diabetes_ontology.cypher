// ==============================================================================
// KNOWLEDGE GRAPH: CHẨN ĐOÁN & ĐIỀU TRỊ BỆNH TIỂU ĐƯỜNG (ĐÁI THÁO ĐƯỜNG)
// Nguồn tri thức y khoa: Chuyên mục Bệnh học & Dược học - Nhà Thuốc Long Châu (nhathuoclongchau.com.vn)
// Ngôn ngữ: Cypher (Neo4j Graph Database)
// ==============================================================================

// ------------------------------------------------------------------------------
// 1. TẠO RÀNG BUỘC DUY NHẤT (CONSTRAINTS) ĐẢM BẢO TÍNH TOÀN VẸN DỮ LIỆU
// ------------------------------------------------------------------------------
CREATE CONSTRAINT unique_disease_id IF NOT EXISTS FOR (d:Disease) REQUIRE d.id IS UNIQUE;
CREATE CONSTRAINT unique_symptom_id IF NOT EXISTS FOR (s:Symptom) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT unique_risk_id IF NOT EXISTS FOR (r:RiskFactor) REQUIRE r.id IS UNIQUE;
CREATE CONSTRAINT unique_metric_id IF NOT EXISTS FOR (m:ClinicalMetric) REQUIRE m.id IS UNIQUE;
CREATE CONSTRAINT unique_comp_id IF NOT EXISTS FOR (c:Complication) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT unique_med_id IF NOT EXISTS FOR (med:Medication) REQUIRE med.id IS UNIQUE;
CREATE CONSTRAINT unique_life_id IF NOT EXISTS FOR (l:LifestyleDiet) REQUIRE l.id IS UNIQUE;
CREATE CONSTRAINT unique_spec_id IF NOT EXISTS FOR (sp:MedicalSpecialty) REQUIRE sp.id IS UNIQUE;

// ------------------------------------------------------------------------------
// 2. TẠO CÁC NỐT THỰC THỂ (NODES)
// ------------------------------------------------------------------------------

// [NODES: BỆNH LÝ - Disease]
MERGE (d_t2:Disease {
    id: "DIS_T2D",
    name: "Đái tháo đường Type 2",
    code_icd10: "E11",
    description: "Tình trạng kháng insulin kết hợp suy giảm tiết insulin tiến triển, chiếm 90-95% ca bệnh",
    source: "nhathuoclongchau.com.vn"
});

MERGE (d_t1:Disease {
    id: "DIS_T1D",
    name: "Đái tháo đường Type 1",
    code_icd10: "E10",
    description: "Bệnh tự miễn phá hủy tế bào beta đảo tụy dẫn đến thiếu hụt insulin tuyệt đối",
    source: "nhathuoclongchau.com.vn"
});

MERGE (d_pre:Disease {
    id: "DIS_PRE",
    name: "Tiền đái tháo đường (Pre-diabetes)",
    code_icd10: "R73.0",
    description: "Mức đường huyết cao hơn bình thường nhưng chưa chạm ngưỡng chẩn đoán tiểu đường",
    source: "nhathuoclongchau.com.vn"
});

MERGE (d_gest:Disease {
    id: "DIS_GEST",
    name: "Đái tháo đường thai kỳ",
    code_icd10: "O24.4",
    description: "Rối loạn dung nạp glucose khởi phát hoặc phát hiện lần đầu trong khi mang thai",
    source: "nhathuoclongchau.com.vn"
});

// [NODES: TRIỆU CHỨNG LÂM SÀNG - Symptom]
MERGE (s_polydipsia:Symptom {id: "SYM_01", name: "Khát nước nhiều (Polydipsia)", severity: "Phổ biến", note: "Uống nhiều nước nhưng miệng vẫn luôn khô"});
MERGE (s_polyuria:Symptom {id: "SYM_02", name: "Đi tiểu nhiều lần (Polyuria)", severity: "Phổ biến", note: "Đặc biệt đi tiểu nhiều lần về ban đêm"});
MERGE (s_polyphagia:Symptom {id: "SYM_03", name: "Ăn nhiều, nhanh đói (Polyphagia)", severity: "Trung bình", note: "Cơ thể không chuyển hóa được glucose tạo năng lượng"});
MERGE (s_weightloss:Symptom {id: "SYM_04", name: "Sụt cân bất thường không rõ nguyên nhân", severity: "Báo động", note: "Cơ thể đốt mỡ và cơ bắp để tạo năng lượng"});
MERGE (s_fatigue:Symptom {id: "SYM_05", name: "Mệt mỏi kiệt sức kéo dài", severity: "Phổ biến", note: "Tế bào thiếu hụt năng lượng vận hành"});
MERGE (s_blurred_vision:Symptom {id: "SYM_06", name: "Mờ mắt, thị lực giảm sút", severity: "Cảnh báo sớm biến chứng", note: "Mao mạch võng mạc bị tổn thương do đường huyết cao"});
MERGE (s_numbness:Symptom {id: "SYM_07", name: "Tê bì, châm chích bàn tay bàn chân", severity: "Báo động biến chứng thần kinh", note: "Tổn thương dây thần kinh ngoại biên"});
MERGE (s_slow_healing:Symptom {id: "SYM_08", name: "Vết thương, vết trầy xước lâu lành", severity: "Báo động", note: "Lưu thông máu kém và suy giảm miễn dịch"});

// [NODES: YẾU TỐ NGUY CƠ - RiskFactor]
MERGE (r_bmi:RiskFactor {id: "RISK_BMI", name: "Thừa cân / Béo phì (BMI >= 23 kg/m² theo chuẩn Châu Á)", category: "Thể trạng", modifiable: true});
MERGE (r_age:RiskFactor {id: "RISK_AGE", name: "Tuổi tác >= 45 tuổi", category: "Nhân khẩu học", modifiable: false});
MERGE (r_family:RiskFactor {id: "RISK_FAMILY", name: "Tiền sử gia đình có người mắc tiểu đường (Di truyền)", category: "Di truyền", modifiable: false});
MERGE (r_hypertension:RiskFactor {id: "RISK_HTN", name: "Huyết áp cao (>= 140/90 mmHg)", category: "Bệnh lý kết hợp", modifiable: true});
MERGE (r_sedentary:RiskFactor {id: "RISK_SEDENTARY", name: "Lối sống ít vận động, lười thể dục", category: "Lối sống", modifiable: true});
MERGE (r_dyslipidemia:RiskFactor {id: "RISK_LIPID", name: "Rối loạn mỡ máu (HDL thấp, Triglyceride cao)", category: "Chuyển hóa", modifiable: true});
MERGE (r_history_gest:RiskFactor {id: "RISK_HIST_GEST", name: "Từng mắc tiểu đường thai kỳ hoặc sinh con > 4kg", category: "Tiền sử sản khoa", modifiable: false});

// [NODES: CHỈ SỐ LÂM SÀNG & CẬN LÂM SÀNG - ClinicalMetric]
MERGE (m_glucose:ClinicalMetric {
    id: "METRIC_GLUCOSE",
    name: "Glucose huyết tương lúc đói (Fasting Plasma Glucose)",
    unit: "mg/dL",
    normal_range: "70 - 99 mg/dL",
    prediabetes_range: "100 - 125 mg/dL",
    diabetes_threshold: ">= 126 mg/dL",
    source: "ADA & Long Châu"
});

MERGE (m_hba1c:ClinicalMetric {
    id: "METRIC_HBA1C",
    name: "Chỉ số HbA1c (Đường huyết trung bình 3 tháng)",
    unit: "%",
    normal_range: "< 5.7%",
    prediabetes_range: "5.7% - 6.4%",
    diabetes_threshold: ">= 6.5%",
    source: "ADA & Long Châu"
});

MERGE (m_ogtt:ClinicalMetric {
    id: "METRIC_OGTT",
    name: "Nghiệm pháp dung nạp Glucose đường uống (OGTT 2h)",
    unit: "mg/dL",
    normal_range: "< 140 mg/dL",
    prediabetes_range: "140 - 199 mg/dL",
    diabetes_threshold: ">= 200 mg/dL",
    source: "ADA & Long Châu"
});

MERGE (m_bmi:ClinicalMetric {
    id: "METRIC_BMI",
    name: "Chỉ số khối cơ thể (Body Mass Index - BMI)",
    unit: "kg/m²",
    normal_range: "18.5 - 22.9 kg/m² (Chuẩn Châu Á IDI & WPRO)",
    overweight_threshold: ">= 23 kg/m²",
    obese_threshold: ">= 25 kg/m²"
});

MERGE (m_bp:ClinicalMetric {
    id: "METRIC_BP",
    name: "Huyết áp tâm trương / tâm thu",
    unit: "mmHg",
    normal_range: "< 120/80 mmHg",
    hypertension_threshold: ">= 140/90 mmHg"
});

// [NODES: BIẾN CHỨNG NGUY HIỂM - Complication]
MERGE (c_retinopathy:Complication {id: "COMP_EYE", name: "Bệnh võng mạc đái tháo đường (Gây suy giảm thị lực, mù lòa)", organ: "Mắt", type: "Mạch máu nhỏ"});
MERGE (c_nephropathy:Complication {id: "COMP_KIDNEY", name: "Bệnh thận đái tháo đường (Suy thận mạn tính)", organ: "Thận", type: "Mạch máu nhỏ"});
MERGE (c_neuropathy:Complication {id: "COMP_NERVE", name: "Bệnh thần kinh ngoại biên (Mất cảm giác, tê bì)", organ: "Hệ thần kinh", type: "Thần kinh"});
MERGE (c_foot:Complication {id: "COMP_FOOT", name: "Biến chứng bàn chân đái tháo đường (Loét, nhiễm trùng, nguy cơ đoạn chi)", organ: "Bàn chân", type: "Kết hợp"});
MERGE (c_cvd:Complication {id: "COMP_HEART", name: "Bệnh tim mạch & Xơ vữa động mạch vành", organ: "Tim mạch", type: "Mạch máu lớn"});
MERGE (c_stroke:Complication {id: "COMP_STROKE", name: "Đột quỵ não / Tai biến mạch máu não", organ: "Não", type: "Mạch máu lớn"});

// [NODES: DƯỢC PHẨM & HOẠT CHẤT ĐIỀU TRỊ - Medication]
MERGE (med_metformin:Medication {
    id: "MED_MET",
    name: "Metformin (Glucophage)",
    drug_class: "Biguanide",
    mechanism: "Giảm sản xuất glucose tại gan, tăng độ nhạy cảm insulin ở mô ngoại vi",
    first_line_choice: true,
    common_brand: "Glucophage 500mg/850mg/1000mg tại Nhà Thuốc Long Châu"
});

MERGE (med_gliclazide:Medication {
    id: "MED_GLI",
    name: "Gliclazide (Diamicron MR)",
    drug_class: "Sulfonylurea",
    mechanism: "Kích thích tế bào beta tuyến tụy tăng tiết insulin tự nhiên",
    first_line_choice: false,
    common_brand: "Diamicron MR 30mg/60mg"
});

MERGE (med_dapa:Medication {
    id: "MED_DAPA",
    name: "Dapagliflozin (Forxiga)",
    drug_class: "SGLT-2 Inhibitor",
    mechanism: "Ức chế tái hấp thu glucose ở ống thận, thải bớt đường qua nước tiểu, bảo vệ tim thận",
    first_line_choice: false,
    common_brand: "Forxiga 10mg"
});

MERGE (med_insulin_basal:Medication {
    id: "MED_INS_BASAL",
    name: "Insulin nền (Lantus / Glargine)",
    drug_class: "Insulin Analog tác dụng kéo dài",
    mechanism: "Cung cấp insulin liên tục 24h duy trì đường huyết ổn định cả ngày",
    first_line_choice: false,
    common_brand: "Bút tiêm Lantus SoloStar 100 IU/ml"
});

MERGE (med_insulin_rapid:Medication {
    id: "MED_INS_RAPID",
    name: "Insulin tác dụng nhanh (Novorapid)",
    drug_class: "Insulin Analog tác dụng nhanh",
    mechanism: "Kiểm soát đỉnh đường huyết tăng vọt ngay sau mỗi bữa ăn",
    first_line_choice: false,
    common_brand: "Novorapid FlexPen 100 U/ml"
});

// [NODES: CHẾ ĐỘ DINH DƯỠNG & LỐI SỐNG - LifestyleDiet]
MERGE (l_low_gi:LifestyleDiet {id: "LIFE_LOW_GI", name: "Chế độ ăn giảm tinh bột tinh chế, ưu tiên thực phẩm chỉ số đường huyết thấp (Low GI)", type: "Dinh dưỡng", priority: "Bắt buộc"});
MERGE (l_fiber:LifestyleDiet {id: "LIFE_FIBER", name: "Tăng cường chất xơ hòa tan (Rau xanh, yến mạch, các loại đậu)", type: "Dinh dưỡng", priority: "Khuyến nghị"});
MERGE (l_exercise:LifestyleDiet {id: "LIFE_EXERCISE", name: "Vận động thể lực vừa phải ít nhất 150 phút/tuần (Đi bộ nhanh 30 phút/ngày)", type: "Vận động", priority: "Bắt buộc"});
MERGE (l_weight_control:LifestyleDiet {id: "LIFE_WEIGHT", name: "Kiểm soát cân nặng, giảm 5-7% trọng lượng cơ thể nếu thừa cân", type: "Thể trạng", priority: "Rất cao"});
MERGE (l_foot_care:LifestyleDiet {id: "LIFE_FOOTCARE", name: "Kiểm tra và vệ sinh bàn chân hàng ngày, không đi chân trần", type: "Chăm sóc", priority: "Quan trọng"});
MERGE (l_blood_monitor:LifestyleDiet {id: "LIFE_MONITOR", name: "Tự đo và theo dõi đường huyết mao mạch định kỳ tại nhà", type: "Theo dõi", priority: "Thiết yếu"});

// [NODES: CHUYÊN KHOA Y TẾ - MedicalSpecialty]
MERGE (sp_endo:MedicalSpecialty {id: "SPEC_ENDO", name: "Khoa Nội tiết - Đái tháo đường", role: "Chẩn đoán & phác đồ điều trị chuyên sâu"});
MERGE (sp_nutri:MedicalSpecialty {id: "SPEC_NUTRI", name: "Khoa Dinh dưỡng lâm sàng", role: "Thiết kế thực đơn cá nhân hóa kiểm soát đường huyết"});
MERGE (sp_cardio:MedicalSpecialty {id: "SPEC_CARDIO", name: "Khoa Tim mạch", role: "Tầm soát và điều trị biến chứng tim mạch kết hợp"});


// ------------------------------------------------------------------------------
// 3. TẠO CÁC MỐI QUAN HỆ (RELATIONSHIPS)
// ------------------------------------------------------------------------------

// Bệnh lý -> Triệu chứng
MERGE (d_t2)-[:HAS_SYMPTOM {frequency: "Rất cao"}]->(s_polydipsia);
MERGE (d_t2)-[:HAS_SYMPTOM {frequency: "Rất cao"}]->(s_polyuria);
MERGE (d_t2)-[:HAS_SYMPTOM {frequency: "Thường gặp"}]->(s_fatigue);
MERGE (d_t2)-[:HAS_SYMPTOM {frequency: "Giai đoạn tiến triển"}]->(s_blurred_vision);
MERGE (d_t2)-[:HAS_SYMPTOM {frequency: "Giai đoạn biến chứng"}]->(s_numbness);
MERGE (d_t2)-[:HAS_SYMPTOM {frequency: "Thường gặp"}]->(s_slow_healing);

MERGE (d_t1)-[:HAS_SYMPTOM {onset: "Đột ngột, dữ dội"}]->(s_weightloss);
MERGE (d_t1)-[:HAS_SYMPTOM {onset: "Đột ngột"}]->(s_polydipsia);
MERGE (d_t1)-[:HAS_SYMPTOM {onset: "Đột ngột"}]->(s_polyuria);
MERGE (d_t1)-[:HAS_SYMPTOM {onset: "Đột ngột"}]->(s_polyphagia);

MERGE (d_pre)-[:HAS_SYMPTOM {note: "Thường diễn tiến âm thầm, không triệu chứng rõ rệt"}]->(s_fatigue);

// Bệnh lý -> Yếu tố nguy cơ
MERGE (d_t2)-[:HAS_RISK_FACTOR {impact_level: "Rất cao"}]->(r_bmi);
MERGE (d_t2)-[:HAS_RISK_FACTOR {impact_level: "Cao"}]->(r_age);
MERGE (d_t2)-[:HAS_RISK_FACTOR {impact_level: "Cao"}]->(r_family);
MERGE (d_t2)-[:HAS_RISK_FACTOR {impact_level: "Trung bình"}]->(r_hypertension);
MERGE (d_t2)-[:HAS_RISK_FACTOR {impact_level: "Cao"}]->(r_sedentary);
MERGE (d_t2)-[:HAS_RISK_FACTOR {impact_level: "Trung bình"}]->(r_dyslipidemia);

MERGE (d_gest)-[:HAS_RISK_FACTOR]->(r_history_gest);
MERGE (d_gest)-[:HAS_RISK_FACTOR]->(r_bmi);

// Bệnh lý -> Biến chứng
MERGE (d_t2)-[:CAUSES_COMPLICATION {timeframe: "Mạn tính sau 5-10 năm kiểm soát kém"}]->(c_retinopathy);
MERGE (d_t2)-[:CAUSES_COMPLICATION {timeframe: "Mạn tính"}]->(c_nephropathy);
MERGE (d_t2)-[:CAUSES_COMPLICATION {timeframe: "Mạn tính"}]->(c_neuropathy);
MERGE (d_t2)-[:CAUSES_COMPLICATION {danger_level: "Nguy kịch"}]->(c_foot);
MERGE (d_t2)-[:CAUSES_COMPLICATION {danger_level: "Nguyên nhân tử vong hàng đầu"}]->(c_cvd);
MERGE (d_t2)-[:CAUSES_COMPLICATION {danger_level: "Đe dọa tính mạng"}]->(c_stroke);

// Bệnh lý -> Tiêu chuẩn chẩn đoán (ClinicalMetric)
MERGE (d_t2)-[:DIAGNOSED_BY {threshold: ">= 126 mg/dL sau nhịn ăn >= 8h"}]->(m_glucose);
MERGE (d_t2)-[:DIAGNOSED_BY {threshold: ">= 6.5%"}]->(m_hba1c);
MERGE (d_t2)-[:DIAGNOSED_BY {threshold: ">= 200 mg/dL"}]->(m_ogtt);
MERGE (d_pre)-[:DIAGNOSED_BY {threshold: "100 - 125 mg/dL"}]->(m_glucose);
MERGE (d_pre)-[:DIAGNOSED_BY {threshold: "5.7% - 6.4%"}]->(m_hba1c);

// Bệnh lý -> Dược phẩm điều trị (Medication)
MERGE (d_t2)-[:TREATED_WITH {line: "Lựa chọn đầu tay (First-line)"}]->(med_metformin);
MERGE (d_t2)-[:TREATED_WITH {line: "Phối hợp điều trị thứ hai"}]->(med_gliclazide);
MERGE (d_t2)-[:TREATED_WITH {line: "Phối hợp ưu tiên nếu có nguy cơ tim thận"}]->(med_dapa);
MERGE (d_t2)-[:TREATED_WITH {line: "Giai đoạn muộn khi thuốc uống không đạt mục tiêu"}]->(med_insulin_basal);

MERGE (d_t1)-[:TREATED_WITH {line: "Bắt buộc suốt đời (Lifelong replacement)"}]->(med_insulin_basal);
MERGE (d_t1)-[:TREATED_WITH {line: "Bắt buộc trước mỗi bữa ăn"}]->(med_insulin_rapid);

// Bệnh lý -> Lối sống & Dinh dưỡng (Lifestyle)
MERGE (d_t2)-[:MANAGED_BY {effectiveness: "Nền tảng kiểm soát"}]->(l_low_gi);
MERGE (d_t2)-[:MANAGED_BY {effectiveness: "Giảm hấp thu đường"}]->(l_fiber);
MERGE (d_t2)-[:MANAGED_BY {effectiveness: "Tăng độ nhạy Insulin"}]->(l_exercise);
MERGE (d_t2)-[:MANAGED_BY {effectiveness: "Đảo ngược kháng insulin"}]->(l_weight_control);
MERGE (d_t2)-[:MANAGED_BY {effectiveness: "Phòng ngừa loét cắt cụt"}]->(l_foot_care);
MERGE (d_t2)-[:MANAGED_BY {effectiveness: "Theo dõi đáp ứng điều trị"}]->(l_blood_monitor);

MERGE (d_pre)-[:MANAGED_BY {goal: "Ngăn chặn tiến triển thành đái tháo đường thực sự"}]->(l_weight_control);
MERGE (d_pre)-[:MANAGED_BY]->(l_exercise);
MERGE (d_pre)-[:MANAGED_BY]->(l_low_gi);

// Yếu tố nguy cơ -> Chỉ số lâm sàng
MERGE (r_bmi)-[:MEASURED_BY]->(m_bmi);
MERGE (r_hypertension)-[:MEASURED_BY]->(m_bp);

// Bệnh lý -> Tư vấn chuyên khoa
MERGE (d_t2)-[:CONSULT_SPECIALTY]->(sp_endo);
MERGE (d_t2)-[:CONSULT_SPECIALTY]->(sp_nutri);
MERGE (d_t2)-[:CONSULT_SPECIALTY]->(sp_cardio);\n