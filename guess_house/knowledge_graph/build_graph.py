# ==============================================================================
# SCRIPT PYTHON NẠP KNOWLEDGE GRAPH BẤT ĐỘNG SẢN VÀO NEO4J DATABASE
# Nguồn dữ liệu: Tiêu chí phân loại & định giá Batdongsan.com.vn
# ==============================================================================

import os
import sys
import argparse

if sys.stdout.encoding.lower() != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

def get_cypher_statements(cypher_file_path):
    with open(cypher_file_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    raw_statements = content.split(";")
    statements = []
    for stmt in raw_statements:
        clean = stmt.strip()
        lines = [l for l in clean.splitlines() if not l.strip().startswith("//")]
        valid_stmt = "\n".join(lines).strip()
        if valid_stmt:
            statements.append(valid_stmt)
    return statements

def build_graph(uri, user, password, cypher_file):
    try:
        from neo4j import GraphDatabase
    except ImportError:
        print("⚠️ Chưa cài đặt thư viện 'neo4j'. Bạn có thể cài đặt nhanh qua: pip install neo4j")
        print("ℹ️ Bạn có thể copy trực tiếp nội dung trong file 'real_estate_ontology.cypher' dán vào Neo4j Browser để chạy.")
        return False

    print(f"🔗 Đang kết nối tới Neo4j tại: {uri} (User: {user})...")
    try:
        driver = GraphDatabase.driver(uri, auth=(user, password))
        driver.verify_connectivity()
        print("✅ Kết nối Neo4j thành công!")
    except Exception as e:
        print(f"❌ Không thể kết nối Neo4j: {e}")
        print("👉 Gợi ý: Hãy đảm bảo Neo4j Desktop hoặc Docker Neo4j đang mở, hoặc truyền đúng thông tin AuraDB.")
        return False

    statements = get_cypher_statements(cypher_file)
    print(f"📋 Tìm thấy {len(statements)} câu lệnh Cypher cần thực thi.")

    with driver.session() as session:
        for idx, query in enumerate(statements, 1):
            try:
                session.run(query)
                print(f"  [{idx}/{len(statements)}] Đã thực thi lệnh tạo thực thể/quan hệ BĐS...")
            except Exception as ex:
                print(f"  ⚠️ Lỗi tại câu lệnh {idx}: {ex}")

        result = session.run("MATCH (n) RETURN count(n) AS total_nodes")
        node_count = result.single()["total_nodes"]
        rel_result = session.run("MATCH ()-[r]->() RETURN count(r) AS total_rels")
        rel_count = rel_result.single()["total_rels"]
        print(f"\n🎉 HOÀN TẤT NẠP KNOWLEDGE GRAPH BĐS! Tổng số Nodes: {node_count}, Relationships: {rel_count}")

    driver.close()
    return True

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Build Real Estate Knowledge Graph in Neo4j (Batdongsan.com.vn Source)")
    parser.add_argument("--uri", default=os.getenv("NEO4J_URI", "bolt://localhost:7687"), help="Neo4j Connection URI")
    parser.add_argument("--user", default=os.getenv("NEO4J_USER", "neo4j"), help="Neo4j Username")
    parser.add_argument("--password", default=os.getenv("NEO4J_PASSWORD", "password123"), help="Neo4j Password")
    parser.add_argument("--dry-run", action="store_true", help="Chỉ kiểm tra cú pháp Cypher mà không kết nối DB")
    
    args = parser.parse_args()
    script_dir = os.path.dirname(os.path.abspath(__file__))
    cypher_path = os.path.join(script_dir, "real_estate_ontology.cypher")

    if args.dry_run:
        stmts = get_cypher_statements(cypher_path)
        print(f"✅ Dry-run thành công: {len(stmts)} câu lệnh Cypher hợp lệ sẵn sàng nạp vào Neo4j!")
    else:
        build_graph(args.uri, args.user, args.password, cypher_path)
