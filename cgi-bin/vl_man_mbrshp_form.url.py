#!/usr/bin/env python3

# Here is a good example for python CGI scripts:
# https://www.tutorialspoint.com/python/python_cgi_programming.htm

# Import modules for CGI handling
import cgi
import cgitb

# Create instance of FieldStorage
form = cgi.FieldStorage()

print("Content-type:text/html\r\n\r\n")
print("<html>")
print("<head>")
for key in form.keys():
    print(f"{key} {form[key]}\r\n")
print("</body>")
print("</html>")
