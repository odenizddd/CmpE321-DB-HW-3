from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from django.db import connection

def login(request):

    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM Player")
        rows = cursor.fetchall()

    return render(request, 'login.html', {'rows': rows})