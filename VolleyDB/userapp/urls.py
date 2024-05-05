from django.urls import path
from . import views

urlpatterns = [
    path("", views.login),
    path("DatabaseManager/<str:username>", views.databaseManager),
    path("Player/<str:username>", views.player),
    path("Jury/<str:username>", views.jury),
    path("Coach/<str:username>", views.coach),
    path("AddPlayer", views.addPlayer),
    path("AddCoach", views.addCoach),
    path("AddJury", views.addJury),
    path("ChangeStadiumName", views.changeStadiumName),
]