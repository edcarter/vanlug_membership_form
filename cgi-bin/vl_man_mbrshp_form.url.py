#!/usr/bin/env python3
"""
This CGI script is responsible for taking the new-member
form data and inserting that data into a mysql table.

Here are some good links to look at in order to understand this script:
https://www.tutorialspoint.com/python/python_cgi_programming.htm
https://docs.python.org/3.6/library/cgi.html
https://docs.python.org/3.6/library/cgitb.html
https://dev.mysql.com/doc/connector-python/en/connector-python-example-cursor-transaction.html
"""


import cgi
import cgitb
import os

import mysql.connector

# Dump error logs to the same directory where this script lives
logfile_dir = os.path.abspath(os.path.dirname(__file__))
cgitb.enable(logdir=logfile_dir)

membership_db = mysql.connector.connect(
    host="localhost",
    user="yourusername",
    password="yourpassword",
    database="mydatabase"
)

# Create instance of FieldStorage
form = cgi.FieldStorage()
id_obt = form.getvalue("id_obt", None)
id_vlmbr_obt = form.getvalue("id_vlmbr_obt", None)
id_pmp = form.getvalue("id_pmp", None)
id_pmp_usr = form.getvalue("id_pmp_usr", None)
id_vfb = form.getvalue("id_vfb", None)
id_vfb_usr = form.getvalue("id_vfb_usr", None)
fname = form.getvalue("fname", None)
lname = form.getvalue("lname", None)
email = form.getvalue("email", None)
usrname = form.getvalue("usrname", None)
password = form.getvalue("password", None)
phone_num = form.getvalue("phone_num", None)
addr1 = form.getvalue("addr1", None)
addr2 = form.getvalue("addr2", None)
city = form.getvalue("city", None)
prov_state = form.getvalue("prov_state", None)
postalc_zip = form.getvalue("postalc_zip", None)
comments_exprtise = form.getvalue("comments_exprtise", None)
start_date = form.getvalue("start_date", None)
expir_date = form.getvalue("expir_date", None)
mbr_status = form.getvalue("mbr_status", None)
brd_posit = form.getvalue("brd_posit", None)
keypunch = form.getvalue("keypunch", None)
paymt_type = form.getvalue("paymt_type", None)
amount = form.getvalue("amount", None)
donation = form.getvalue("donation", None)
subtotal = form.getvalue("subtotal", None)
total = form.getvalue("total", None)

cursor = membership_db.cursor()
QUERY = ("INSERT INTO membership_obt "
         "(id_obt, id_vlmbr_obt, id_pmp, id_pmp_usr, id_vfb, id_vfb_usr, fname, lname,"
         "email, usrname, password, phone_num, addr1, addr2, city, prov_state, postalc_zip,"
         "comments_exprtise, start_date, expir_date, mbr_status, brd_posit, keypunch,"
         "paymt_type, amount, donation, subtotal, total) "
         "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, "
         "%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
params = (id_obt, id_vlmbr_obt, id_pmp, id_pmp_usr, id_vfb, id_vfb_usr, fname, lname,
          email, usrname, password, phone_num, addr1, addr2, city, prov_state, postalc_zip,
          comments_exprtise, start_date, expir_date, mbr_status, brd_posit, keypunch,
          paymt_type, amount, donation, subtotal, total)

cursor.execute(QUERY, params)
membership_db.commit()
membership_db.close()

print("Content-type:text/plain\n")
print("Status: 201 CREATED\n")
print("Successfully added a member!\n")
