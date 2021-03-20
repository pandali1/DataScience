import pymysql as pml


conn = pml.connect(host='127.0.0.1',port = 3306,user='root',password='123456',database='mytest',charset='utf8')


cur = conn.cursor() 



sql = """
select *
from babyinfo
limit 5;
"""


cur.execute(sql)


cur.fetchall() 


import pandas as pd 
pd.read_sql(sql,conn)


def con_mysql(sql):
    """
    sql:查询语句
    返回：查询结果，dataframe
    """
    from pandas import read_sql
    from pymysql import connect
    conn = connect(host='127.0.0.1',port = 3306,user='root',password='123456',database='mytest',charset='utf8')
    df=read_sql(sql,conn)
    # 关闭数据库连接
    conn.close()
    return df



cur.close() 
conn.close()

