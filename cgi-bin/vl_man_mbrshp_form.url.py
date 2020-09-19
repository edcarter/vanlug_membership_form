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

# BUG: if mysql is imported after the cgi libraries the process segmentation faults.
# the simple fix is to import the mysql connector first.
# More information is here: https://bugs.mysql.com/bug.php?id=97220
import mysql.connector

import cgi
import cgitb
import datetime
import os


def get_cgi_int(fieldstorage, field):
    value = fieldstorage.getvalue(field, None)
    if value:
        value = int(value)
    return value

def get_cgi_str(fieldstorage, field):
    return fieldstorage.getvalue(field, None)

def get_cgi_date(fieldstorage, field):
    """
    Parse a HTML5 date string into a python date type

    """
    value = fieldstorage.getvalue(field, None)
    if value:
        value = datetime.datetime.strptime(value, '%Y-%m-%d').date()
    return value


# Dump error logs to the same directory where this script lives
logfile_dir = os.path.abspath(os.path.dirname(__file__))
cgitb.enable(logdir=logfile_dir)

membership_db = mysql.connector.connect(
    host="localhost",
    user="test",
    password="test",
    database="vanlug_membership"
)

form = cgi.FieldStorage()
id_obt = get_cgi_int(form, "id_obt")
id_vlmbr = get_cgi_int(form, "id_vlmbr_increment") #TODO: these are different?
id_pmp = get_cgi_int(form, "id_pmp")
id_pmp_usr = get_cgi_int(form, "id_pmp_usr")
id_vfb = get_cgi_int(form, "id_vfb")
id_vfb_usr = get_cgi_int(form, "id_vfb_usr")
fname = get_cgi_str(form, "fname")
lname = get_cgi_str(form, "lname")
email = get_cgi_str(form, "email")
usrname = get_cgi_str(form, "usrname")
password = get_cgi_str(form, "passwd") #TODO: these are different?
phone_num = get_cgi_str(form, "phone_num")
addr1 = get_cgi_str(form, "addr1")
addr2 = get_cgi_str(form, "addr2")
city = get_cgi_str(form, "city")
prov_state = get_cgi_str(form, "prov_state")
postalc_zip = get_cgi_str(form, "postalc_zip")
country = get_cgi_str(form, "country")
comments_expertise = get_cgi_str(form, "comments_expertise")
start_date = get_cgi_date(form, "start_date")
expir_date = get_cgi_date(form, "expir_date")
mbr_status = get_cgi_str(form, "mbr_status")
brd_posit = get_cgi_str(form, "brd_posit")
keypunch = get_cgi_str(form, "keypunch")
paymt_type = get_cgi_str(form, "paymt_type")
amount = get_cgi_str(form, "amount")
donation = get_cgi_str(form, "donation")
subtotal = get_cgi_str(form, "subtotal")
total = get_cgi_str(form, "total")
gateway = get_cgi_str(form, "gateway")

cursor = membership_db.cursor()
QUERY = ("INSERT INTO membership_obt "
         "(id_obt, id_vlmbr, id_pmp, id_pmp_usr, id_vfb, id_vfb_usr, fname, lname,"
         "email, usrname, password, phone_num, addr1, addr2, city, prov_state, postalc_zip,"
         "country, comments_expertise, start_date, expir_date, mbr_status, brd_posit, keypunch,"
         "paymt_type, amount, donation, subtotal, total, gateway) "
         "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, "
         "%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
params = (id_obt, id_vlmbr, id_pmp, id_pmp_usr, id_vfb, id_vfb_usr, fname, lname,
          email, usrname, password, phone_num, addr1, addr2, city, prov_state, postalc_zip,
          country, comments_expertise, start_date, expir_date, mbr_status, brd_posit, keypunch,
          paymt_type, amount, donation, subtotal, total, gateway)
cursor.execute(QUERY, params)
membership_db.commit()
membership_db.close()

print("Content-type:text/plain\n")
print("Status: 201 CREATED\n")
print("Successfully added a member!\n")
