import json
from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework import viewsets
from .models import Product, UserInfo, ShoppingList, Shopping
from .serializers import ProductSerializer, UserInfoSerializer, ShoppingSerializer,ShoppingListSerializer
import random
from django.http import HttpResponse
import cv2, torch, math
import sys, numpy as np
from yolov7.detect import detect
import ast, time
Path = 'C:/Users/user/Desktop/flutterProject_202304-hyeonseok/capston/yolov7'
sys.path.insert(0, 'C:/Users/user/Desktop/flutterProject_202304-hyeonseok/capston/yolov7')
import datetime
# img = cv2.imread('C:/detect/3.jpg')

# model = torch.hub.load(Path, 'custom', Path+'/capston_best6.pt', source='local')
# aa = model(img, size = 640)
# aa.render()

# for i in aa.imgs:
#     bb = np.array(i)
#     cv2.imwrite('C:/detect/asdf3.jpg',bb)


# 앱 저장 데이터
product_name = {}
product_name['00_kanu_16g'] = '맥심) 카누 마일드 아메리카노 16g'
product_name['01_spam_200g'] = 'CJ) 스팸 클래식 200g'
product_name['02_tuna_250g'] = '동원) 고추참치 250g'
product_name['03_homerunball_46g'] = '해태) 홈런볼 초코 46g'
product_name['04_curry_200g'] = '오뚜기) 3분카레 약간매운맛'
product_name['05_dreamcacao_86g'] = '롯데) 드림카카오72% 86g'
product_name['06_wipes_181g'] = '크리넥스) 수앤수 실키소프트 오리지널'
product_name['07_eclipse_30g'] = '한국마즈) 이클립스 워터멜론향 30g'
product_name['08_pocarisweat_340ml'] = '포카리스웨트 340ml'
product_name['09_cocacola_355ml'] = '코카콜라 355ml'
product_name['10_buldalg_200g'] = '삼양) 불닭소스 200g'
product_name['11_buldalgmayo_250g'] = '삼양) 불닭마요 250g'

def clamp(num, min_value, max_value):
   return max(min(num, max_value), min_value)

# // Detection 및 flutter 앱 연동 학습용 코드
# @api_view(['GET'])
# def helloAPI(request):
    
#     b = cv2.cvtColor(cv2.imread('C:/detect/3.jpg'),cv2.COLOR_BGR2YUV_I420)
#     c = cv2.cvtColor(b,cv2.COLOR_YUV2BGR)
#     result = {}
#     product = []
#     # Y = list(request.data['Y'])
#     # U = list(request.data['U'])
#     # V = list(request.data['V'])
#     # YUVImage = cv2.merge(Y,U,V)
#     # BGRImage = cv2.cvtColor(YUVImage, cv2.YUV2BGR)
#     aas = detect(c)
#     for i,j in zip(aas.keys(), aas.values()):
#         k = ProductSerializer(Product.objects.get(product_name = product_name[i])).data
#         k['product_count'] = j
#         product.append(k)
#     result['result'] = product
#     return Response(result)

@api_view(['POST'])
def caledarLoadDetail(request):
    
    shoppings = Shopping.objects.filter(iden_num = request.data['iden_num'])
    name = []
    price = []
    count = []
    for shopping in shoppings:
        shoppingdata = ShoppingSerializer(shopping).data
        name.append(shoppingdata['product_name'])
        price.append(shoppingdata['price'])
        count.append(shoppingdata['count'])
    return Response({'result':{'names' : name, 'prices' : price, 'counts' : count}})

    
    
    

@api_view(['POST'])
def calendarLoad(request):
    response= []
    print(request.data['email'])
    user = UserInfo.objects.get(user_email = request.data['email'])
    pk = user.user_pk
    shoppingLists = ShoppingList.objects.filter(user_pk = pk, buy_date = request.data['date'][0:10])
    
    
    for shoppingList in shoppingLists:
        result = {}

        result['total_price'] = shoppingList.price
        result['iden_num'] = shoppingList.iden_num
        result['kinds'] = shoppingList.product_kinds - 1
        result['product_sample'] = shoppingList.sample_product.product_name
        result['product_count'] = shoppingList.product_count
        response.append(result)
    return Response({'result':response})

@api_view(['POST'])
def calendarDelete(request):
    iden_num = request.data['iden_num']
    Shopping.objects.filter(iden_num = iden_num).delete()
    ShoppingList.objects.get(iden_num = iden_num).delete()
    return Response({'result': True})
    

@api_view(['POST'])
def Calendar(request):
    email = request.data['email']
    data = []
    user = UserInfo.objects.get(user_email = email)
    try :
        k = ShoppingList.objects.filter(user_pk = user)
        for i in k:

            if i.buy_date not in data:
                data.append(i.buy_date)
    except:
        ''
    return Response({'result': data})


@api_view(['POST'])
def CartMakeList(request):
    
    itemName = request.data['product_name']
    price = request.data['product_price']
    amount = request.data['product_amount']
    
    

    totalPrice = request.data['total_price']
    cv2.COOR_BGR2YUV
    
    user = UserInfo.objects.get(user_email = request.data['email'])
    print(itemName)
    buy_date = datetime.date.today()
    
    a = ShoppingList.objects.create(
        
            iden_num = ShoppingList.objects.last().iden_num + 1,

            buy_date = buy_date,
            user_pk = user,
            price = totalPrice,
            sample_product = Product.objects.get(product_name = itemName[0]),
            product_count = sum(amount),
            product_kinds = len(itemName)
            )
    
    
    for i in range(len(itemName)):
        Shopping.objects.create(
            shopping_id = Shopping.objects.last().shopping_id + 1,
            user_pk = user,
            product_name = Product.objects.get(product_name = itemName[i]),
            price = int(price[i])*int(amount[i]),
            count = amount[i],
            iden_num = a
        )


    return Response({'result' : 200})





@api_view(['POST'])
def Detection(request):
    # h , w = 720, 480
    result = {}
    t1 = time.time()

    Y = request.data['Y']
    U = request.data['U']
    V = request.data['V']
    
    

    for i in range(720 ,345600, 720):
        del Y[i:i+48]
    for j in range(720,172800,720):
        del V[j:j+48]
        
        del U[j:j+48]
        
    V.append(Y[-1])
    U.append(U[-1])
    
    Y= cv2.rotate(np.array(Y).reshape(480,720),cv2.ROTATE_90_CLOCKWISE)
    U1= cv2.rotate(np.array(U[0::4]).reshape(240,180),cv2.ROTATE_90_CLOCKWISE).tolist()
    U2= cv2.rotate(np.array(U[2::4]).reshape(240,180),cv2.ROTATE_90_CLOCKWISE).tolist()
    V1= cv2.rotate(np.array(V[0::4]).reshape(240,180),cv2.ROTATE_90_CLOCKWISE).tolist()
    V2= cv2.rotate(np.array(V[2::4]).reshape(240,180),cv2.ROTATE_90_CLOCKWISE).tolist()
    Ulanes = []
    Vlanes = []
    for k in range(0,180):
        Ulanes.append(U1[k] + U2[k])
        Vlanes.append(V1[k] + V2[k])

    Y = sum(Y.tolist(),[])
    U = sum(Ulanes, [])
    V = sum(Vlanes, [])
    U1 = sum(U1,[])
    U2 = sum(U2,[])
    V1 = sum(V1,[])
    V2 = sum(V2,[])
    YUV = np.array(Y+U+V).reshape(1080,480)
    YUV = np.uint8(YUV)
    BGR = cv2.cvtColor(YUV, cv2.COLOR_YUV2BGR_I420)
    
    aas = detect(BGR)
    product = []
    for i,j in zip(aas.keys(), aas.values()):
        k = ProductSerializer(Product.objects.get(product_name = product_name[i])).data
        k['product_count'] = j
        product.append(k)
    result['result'] = product
    t2 = time.time()
    print(t2-t1)
    return Response(result)
@api_view(['POST'])
def shopping_check(request):
    date = request.data['date']
    
    ''

@api_view(['GET'])
def show(request):
    user_info = UserInfo.objects.get(user_email = 'gustjrajt@naver.com')
    serializer = UserInfoSerializer(user_info)
    print(serializer.data)
    return Response(serializer.data)


# 로그인
@api_view(['POST'])
def Login(request):
    if request.method == 'POST':
        try:
            user_info = UserInfo.objects.get(user_email = request.data['userEmail'],
                                 user_password = request.data['userPassword'])
            serializer = UserInfoSerializer(user_info)
            return Response({'result': serializer.data['user_nickname']})
        except:
            return Response({'result':'0'})

# 회원가입
@api_view(['POST'])
def Register(request):
    if request.method == 'POST':
        if emailcheck(request.data['userEmail']):
            return Response({'result':'0'})
        else:
            
            if nickcheck(request.data['userNickname']):
                return Response({'result':'1'})
            else:
                k = UserInfo.objects.all()

                UserInfo.objects.create(
                    user_pk = len(k),
                    user_email = request.data['userEmail'],
                    user_password = request.data['userPassword'],
                    user_nickname = request.data['userNickname']
                )
                return Response({'result':'2'})

# 
@api_view(['POST'])
def change_email(request):
    if request.method == 'POST':
        if emailcheck(request.data['changeEmail']):
            return Response({'result' : '0'})
        else:
            email = UserInfo.objects.get(user_email = request.data['email'])
            email.user_email = request.data['changeEmail']
            email.save()
            return Response({'result':'2'})
        
        
        
@api_view(['POST'])
def change_password(request):
    if request.method == 'POST':
        try:
            user = UserInfo.objects.get(user_email = request.data['userEmail'])
            user.user_password = request.data['inputPassword']
            user.save()
            return Response({'result':'2'})
        except:
            return Response({'result':'0'})
#닉네임 변경

@api_view(['POST'])
def change_nick(request):
    if request.method == 'POST':
        if nickcheck(request.data['changeNick']):
            return Response({'result' : '0'})
        else:
            user_info = UserInfo.objects.get(user_email = request.data['email'])
            user_info.user_nickname = request.data['changeNick']
            user_info.save()
            return Response({'result':'2'})
        


# 이메일 중복확인
def emailcheck(email):
    try:
        user_info = UserInfo.objects.get(user_email = email)
        return True
    except:
        return False

# 닉네임 중복확인
def nickcheck(nick):
    try:
        user_info = UserInfo.objects.get(user_nickname = nick)
        return True
    except:
        return False

def practice(img):
    cv2.imread("C:/yolov7-main/data/train/images/00_kanu_16g (1).jpg")





