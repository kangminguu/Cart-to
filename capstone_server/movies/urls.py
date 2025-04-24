from django.urls import path, include
from .views import show, Register, Login,change_email, change_nick, change_password, Detection, calendarLoad,CartMakeList,Calendar, calendarDelete,caledarLoadDetail

urlpatterns = [
    path("get/", show),
    path("register", Register),
    path("login",Login),
    path("changeEmail", change_email ),
    path("changeNick", change_nick),
    path('changePassword', change_password),
    path('detection', Detection),
    path('calendarLoad', calendarLoad),
    path('cartMakeList', CartMakeList),
    path('calendar', Calendar),
    path('calendarDelete', calendarDelete),
    path('calendarLoadDetail', caledarLoadDetail)
]