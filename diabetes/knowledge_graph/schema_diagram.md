# Sơ Đồ Tri Thức Knowledge Graph Tiểu Đường (Nhà Thuốc Long Châu)

Cơ sở tri thức được xây dựng dựa trên thông tin y khoa chính thống từ **Nhà Thuốc Long Châu** (`nhathuoclongchau.com.vn`) và phác đồ chẩn đoán của Hiệp hội Đái tháo đường Hoa Kỳ (ADA) / Bộ Y tế.

```mermaid
graph LR
    subgraph Disease_Layer [Bệnh Lý]
        D_T2D["Đái tháo đường Type 2"]
        D_T1D["Đái tháo đường Type 1"]
        D_PRE["Tiền đái tháo đường"]
    end

    subgraph Clinical_Layer [Chỉ Số & Yếu Tố Nguy Cơ]
        M_GLU["Fasting Glucose (>=126 mg/dL)"]
        M_HBA1C["HbA1c (>=6.5%)"]
        R_BMI["Thừa cân BMI >= 23"]
        R_SED["Ít vận động"]
    end

    subgraph Treatment_Layer [Dược Phẩm & Dinh Dưỡng Long Châu]
        MED_MET["Metformin (Glucophage 500/850mg)"]
        MED_GLI["Gliclazide (Diamicron MR)"]
        MED_INS["Insulin Lantus / Novorapid"]
        L_DIET["Chế độ Low GI & Tăng Chất xơ"]
        L_EXE["Đi bộ nhanh 150 phút/tuần"]
    end

    subgraph Complications [Biến Chứng Nguy Hiểm]
        C_RET["Võng mạc (Mù lòa)"]
        C_NEP["Bệnh thận đái tháo đường"]
        C_FOOT["Loét hoại tử bàn chân"]
        C_CVD["Xơ vữa động mạch vành"]
    end

    D_T2D -->|DIAGNOSED_BY| M_GLU
    D_T2D -->|DIAGNOSED_BY| M_HBA1C
    D_T2D -->|HAS_RISK_FACTOR| R_BMI
    D_T2D -->|HAS_RISK_FACTOR| R_SED
    D_T2D -->|TREATED_WITH| MED_MET
    D_T2D -->|TREATED_WITH| MED_GLI
    D_T2D -->|TREATED_WITH| MED_INS
    D_T2D -->|MANAGED_BY| L_DIET
    D_T2D -->|MANAGED_BY| L_EXE
    D_T2D -->|CAUSES_COMPLICATION| C_RET
    D_T2D -->|CAUSES_COMPLICATION| C_NEP
    D_T2D -->|CAUSES_COMPLICATION| C_FOOT
    D_T2D -->|CAUSES_COMPLICATION| C_CVD
```\n