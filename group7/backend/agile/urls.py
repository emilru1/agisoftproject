from django.urls import path
from .views import test_api
from .views import create_user
from .views import create_favourite
from .views import fetch_users
from .views import fetch_favourites
from .views import check_user

urlpatterns = [
    path("api/test/", test_api),
    path("api/createuser/", create_user),
    path("api/createfavourite/", create_favourite),
    path("api/fetchusers/", fetch_users),
    path("api/fetchfavourites/", fetch_favourites),
    path("api/checkuser/", check_user)
]