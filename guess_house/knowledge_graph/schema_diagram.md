# Sơ Đồ Tri Thức Knowledge Graph Bất Động Sản (Batdongsan.com.vn)

Cơ sở tri thức được mô hình hóa dựa trên cấu trúc phân loại danh mục, dữ liệu biến động giá và tiêu chí thẩm định từ cổng thông tin **Batdongsan.com.vn**.

```mermaid
graph LR
    subgraph Location_Layer [Địa Giới Hành Chính]
        P_HN["Hà Nội (Đô thị ĐB)"]
        D_CG["Quận Cầu Giấy (~165 tr/m²)"]
        D_HK["Quận Hoàn Kiếm (~450 tr/m²)"]
        D_NTL["Quận Nam Từ Liêm (~120 tr/m²)"]
    end

    subgraph Property_Layer [Loại Hình & Pháp Lý]
        PT_HOUSE["Nhà riêng thổ cư"]
        PT_TOWN["Nhà mặt phố"]
        PT_APT["Căn hộ chung cư"]
        L_RED["Sổ đỏ / Sổ hồng riêng"]
        L_HDB["Hợp đồng mua bán"]
    end

    subgraph Valuation_Layer [Yếu Tố Định Giá & Tiện Ích]
        F_ALLEY["Hẻm ô tô tránh (+20-30%)"]
        F_FRONT["Mặt tiền rộng >= 4.5m"]
        A_METRO["Gần Tuyến Metro (+15%)"]
        A_UNI["Gần Trường Đại học"]
    end

    subgraph Market_Segment [Phân Khúc Thị Trường]
        S_BUDGET["Bình dân (< 3 Tỷ)"]
        S_MID["Trung cấp (3 - 7 Tỷ)"]
        S_HIGH["Cao cấp (7 - 15 Tỷ)"]
        S_LUX["Siêu sang (> 15 Tỷ)"]
    end

    D_CG -->|BELONGS_TO_PROVINCE| P_HN
    D_HK -->|BELONGS_TO_PROVINCE| P_HN
    D_NTL -->|BELONGS_TO_PROVINCE| P_HN

    PT_HOUSE -->|COMMONLY_HAS_LEGAL| L_RED
    PT_TOWN -->|COMMONLY_HAS_LEGAL| L_RED
    PT_APT -->|COMMONLY_HAS_LEGAL| L_HDB

    D_CG -->|HAS_NOTABLE_AMENITY| A_METRO
    D_CG -->|HAS_NOTABLE_AMENITY| A_UNI
    D_CG -->|DOMINANT_SEGMENT| S_MID

    F_ALLEY -->|BOOSTS_PRICE_BY| PT_HOUSE
    F_FRONT -->|BOOSTS_PRICE_BY| PT_TOWN
    A_METRO -->|APPRECIATES_VALUE| PT_APT
    A_METRO -->|APPRECIATES_VALUE| PT_HOUSE

    PT_HOUSE -->|TYPICAL_PRICE_SEGMENT| S_MID
    PT_TOWN -->|TYPICAL_PRICE_SEGMENT| S_HIGH
    PT_TOWN -->|TYPICAL_PRICE_SEGMENT| S_LUX
```\n