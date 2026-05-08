from django.shortcuts import render
from django.http import JsonResponse
from .models import Users, UserFavourites


def test_api(request):
    return JsonResponse({"message": "Hello från Django"})


def create_user(request):
    username = request.GET.get("username")

    if not username:
        return JsonResponse({"error": "No username was entered"})

    user = Users.objects.create(username=username)

    return JsonResponse({
        "message": f"User {user.username} created",
        "id": user.id
    })


def create_favourite(request):
    username = request.GET.get("username")
    lat = request.GET.get("lat")
    lon = request.GET.get("lon")

    if not username or not lat or not lon:
        return JsonResponse({
            "error": "username, lat or lon not set properly"
        })

    try:
        user = Users.objects.get(username=username)
    except Users.DoesNotExist:
        return JsonResponse({"error": "User does not exist"})

    favourite = UserFavourites.objects.create(
        userid=user,
        lat=lat,
        lon=lon
    )

    return JsonResponse({
        "message": f"Favourite {favourite.id} created"
    })


def fetch_users(request):
    users = Users.objects.all()

    data = []
    for user in users:
        data.append({
            "id": user.id,
            "username": user.username
        })

    return JsonResponse(data, safe=False)


def fetch_favourites(request):
    favourites = UserFavourites.objects.all()

    data = []
    for fav in favourites:
        data.append({
            "id": fav.id,
            "username": fav.userid.username,
            "lat": fav.lat,
            "lon": fav.lon
        })

    return JsonResponse(data, safe=False)

def check_user(request):
    username = request.GET.get("username")

    if not username:
        return JsonResponse({"error": "username is required"})

    exists = Users.objects.filter(username=username).exists()

    return JsonResponse({
        "exists": exists
    })