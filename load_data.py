import psycopg2
import csv

conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="dwh",
    user="postgres",
    password="admin"
)
cur = conn.cursor()

def load_csv(csv_path, table_name):
    # очищаем таблицу перед загрузкой
    cur.execute(f"TRUNCATE TABLE {table_name}")
    print(f"Таблица {table_name} очищена")

    with open(csv_path, 'r', encoding='cp1251') as f:
        reader = csv.DictReader(f, delimiter=',')
        for row in reader:
            columns = list(row.keys())
            values = []
            for key, val in row.items():
                if key == 'account_rk' and (val == '' or val is None):
                    values.append(0)
                else:
                    values.append(val)

            placeholders = ','.join(['%s'] * len(columns))
            sql = f"INSERT INTO {table_name} ({','.join(columns)}) VALUES ({placeholders})"
            cur.execute(sql, values)
    conn.commit()
    print(f"Загружено в {table_name}")


# Загружаем файлы
load_csv('data/deal_info.csv', 'rd.deal_info')
load_csv('data/product_info.csv', 'rd.product')

cur.close()
conn.close()
print("Загрузка завершена")