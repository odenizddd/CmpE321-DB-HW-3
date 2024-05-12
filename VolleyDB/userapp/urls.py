from django.urls import path
from . import views

urlpatterns = [
    path("", views.login),
    path("DatabaseManager/<str:username>", views.databaseManager),
    path("Player/<str:username>", views.player),
    path("Jury/<str:username>", views.jury),
    path("Coach/<str:username>", views.coach),
    path("AddPlayer/<str:username>", views.addPlayer),
    path("AddCoach/<str:username>", views.addCoach),
    path("AddJury/<str:username>", views.addJury),
    path("ChangeStadiumName/<str:username>", views.changeStadiumName),
]