1. wss://api-chat.stayverz.com/api/v1/ws/chat/user/chat-stat/?token=YOUR\_JWT\_TOKEN —-----\> unread message count  
2. In Chat Room: wss://api-chat.stayverz.com/api/v1/ws/chat/user/{conversationId}/?token= —---------\> message  
3. wss://api-chat.stayverz.com/api/v1/ws/chat/user/user-global-room/?token= —-- \> ALL of the user's chat conversations updates

1. wss://api-chat.stayverz.com/api/v1/ws/chat/user/chat-stat/?token=YOUR\_JWT\_TOKEN\_HERE

	**payload** \-\> dont need to send any data  
	**response**\-\>    
	{  "count": 5 }

2. wss://api-chat.stayverz.com/api/v1/ws/chat/user/user-global-room/ —--------

**Payload \-\> every 30 second for keep connection alive**  
{  
 "type": "ping"  
}

Device A:  
**Request url \-\>** wss://api-chat.stayverz.com/api/v1/ws/chat/user/{conversationId}/?token=YOUR\_JWT\_TOKEN\_HERE  
Device B:  
**Response url \-\>** wss://api-chat.stayverz.com/api/v1/ws/chat/user/user-global-room/?token=YOUR\_JWT\_TOKEN\_HERE

**Live status of a user:**  
**`When a user start the app send ->`**`{ "action": "join", "user_id": 497 }`  
`Response Get in global room`

**`When a user exit the app send ->`**`{ "action": "leave", "user_id": 497 }`  
`Response Get in global room`

**Typing status of a user \-\>**  
	  
**Start texting \-\>**   
`{`  
	`"action": "is_typing",`  
	`"status": true,`  
	`"conversationId": "6855f59cc476caef2d9d5dd6"`  
`}`  
`Response Get in global room`

**Stop texting \-\>**   
`{`  
	`"action": "is_typing",`  
	`"status": false,`  
	`"conversationId": "6855f59cc476caef2d9d5dd6"`  
`}`  
`Response Get in global room`

**Send message \-\>**  
Payload:	  
`{`  
	`"action": "message",`  
	`"message": "my my",`  
	`"conversationId": "6855f59cc476caef2d9d5dd6"`  
`}`

curl --location 'https://api-chat.stayverz.com/api/v1/chat/user/rooms/6814aa522005035b6fe63346/?page=1&limit=1000' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdF9uYW1lIjoiU3llZHVsIiwibGFzdF9uYW1lIjoiSG9xdWUiLCJ1c2VybmFtZSI6IjAxNjI2OTQwNTUwX2d1ZXN0IiwidV90eXBlIjoiZ3Vlc3QiLCJwaG9uZV9udW1iZXIiOiIwMTYyNjk0MDU1MCIsImlzX2FjdGl2ZSI6dHJ1ZSwiZXhwIjoxNzUxNDU3MjQzLCJ0b2tlbl90eXBlIjoiYWNjZXNzIn0.IChfO1UaS-23LUyV0_q52rMyyrhy5mm4MSlf0M0pRMQ'
`Response:`  
`In Global Chat room`  
`{
    "success": true,
    "message": "Status OK",
    "data": [
        {
            "id": "6814aab03c7420aa73727875",
            "user": {
                "id": "66816d043d711784032d8a13",
                "username": "01975991414_host",
                "full_name": "MD Asiful Hossain Abid",
                "user_id": 497,
                "email": "",
                "image": "https://d26o11dgjud8ta.cloudfront.net/profile-image/b8ca0d6f4499404ca67b4dddd421b89f-WhatsAppImage2024-06-30at17.45.12b2010417.jpg",
                "phone_number": "01975991414",
                "last_online": "2025-07-02T13:51:59.108000",
                "online_status": true
            },
            "content": "প্লিজ চেক ইন এবং চেক আউট টাইমটি জানাবেন ",
            "meta": null,
            "created_at": "2025-05-02T17:21:20.758000",
            "updated_at": null,
            "is_read": true,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6814ad133c7420aa73727876",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "Check in 8 pm.\nCheckout 11:30 am",
            "meta": null,
            "created_at": "2025-05-02T17:31:31.987000",
            "updated_at": null,
            "is_read": true,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6814aa522005035b6fe63347",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "Inquiry sent · 1 guest, May 2 - May 3",
            "meta": {
                "listing": "de9f9baa-4e83-468e-aba0-2e8d5037fa65",
                "booking": {
                    "booking_date": {
                        "check_in": "2025-05-02",
                        "check_out": "2025-05-03",
                        "adult": 1,
                        "children": 0,
                        "infant": 0,
                        "pets": 0,
                        "total_guest_count": 1
                    },
                    "checkout_data": {
                        "nights": 1,
                        "booking_price": 1412.0,
                        "guest_service_charge": 35.3,
                        "total_price": 1447.3,
                        "host_service_charge": 141.2,
                        "host_pay_out": 1270.8,
                        "price_info": {
                            "2025-05-02": {
                                "id": 13033,
                                "price": 1412.0,
                                "is_blocked": false,
                                "is_booked": false,
                                "booking_data": {},
                                "note": ""
                            }
                        },
                        "total_profit": 141.2
                    }
                },
                "user": 4449
            },
            "created_at": "2025-05-02T17:19:46.006000",
            "updated_at": "2025-05-02T17:19:46.006000",
            "is_read": true,
            "file": null,
            "m_type": "system",
            "status": null
        },
        {
            "id": "6814aa522005035b6fe63348",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "Available for tonight? ",
            "meta": null,
            "created_at": "2025-05-02T17:19:46.007000",
            "updated_at": "2025-05-02T17:19:46.007000",
            "is_read": true,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6863cba7eac14d7dbd5f46f2",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "my my",
            "meta": null,
            "created_at": "2025-07-01T17:51:03.359000",
            "updated_at": null,
            "is_read": false,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6863ce55eac14d7dbd5f46f3",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "don't book",
            "meta": null,
            "created_at": "2025-07-01T18:02:29.759000",
            "updated_at": null,
            "is_read": false,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6864d8d46b3e866678ff3278",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "Joy joy",
            "meta": null,
            "created_at": "2025-07-02T12:59:32.050000",
            "updated_at": null,
            "is_read": false,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6864ddc96b3e866678ff3279",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "Mario Joy",
            "meta": null,
            "created_at": "2025-07-02T13:20:41.093000",
            "updated_at": null,
            "is_read": false,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6864e104eac14d7dbd5f46f4",
            "user": {
                "id": "66816d043d711784032d8a13",
                "username": "01975991414_host",
                "full_name": "MD Asiful Hossain Abid",
                "user_id": 497,
                "email": "",
                "image": "https://d26o11dgjud8ta.cloudfront.net/profile-image/b8ca0d6f4499404ca67b4dddd421b89f-WhatsAppImage2024-06-30at17.45.12b2010417.jpg",
                "phone_number": "01975991414",
                "last_online": "2025-07-02T13:51:59.108000",
                "online_status": true
            },
            "content": "Yo Yo habibi",
            "meta": null,
            "created_at": "2025-07-02T13:34:28.784000",
            "updated_at": null,
            "is_read": true,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6864e913eac14d7dbd5f46f5",
            "user": {
                "id": "66816d043d711784032d8a13",
                "username": "01975991414_host",
                "full_name": "MD Asiful Hossain Abid",
                "user_id": 497,
                "email": "",
                "image": "https://d26o11dgjud8ta.cloudfront.net/profile-image/b8ca0d6f4499404ca67b4dddd421b89f-WhatsAppImage2024-06-30at17.45.12b2010417.jpg",
                "phone_number": "01975991414",
                "last_online": "2025-07-02T13:51:59.108000",
                "online_status": true
            },
            "content": "No habibi",
            "meta": null,
            "created_at": "2025-07-02T14:08:51.334000",
            "updated_at": null,
            "is_read": false,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6864ea41f183159f6506f626",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "hi there",
            "meta": null,
            "created_at": "2025-07-02T14:13:53.514000",
            "updated_at": null,
            "is_read": false,
            "file": null,
            "m_type": "normal",
            "status": null
        },
        {
            "id": "6864eafff183159f6506f627",
            "user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "content": "0171699@881",
            "meta": null,
            "created_at": "2025-07-02T14:17:03.802000",
            "updated_at": null,
            "is_read": false,
            "file": null,
            "m_type": "normal",
            "status": null
        }
    ],
    "extra_data": {
        "chat_room": {
            "id": "6814aa522005035b6fe63346",
            "name": "01626940550_guest:01975991414_host",
            "from_user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "to_user": {
                "id": "66816d043d711784032d8a13",
                "username": "01975991414_host",
                "full_name": "MD Asiful Hossain Abid",
                "user_id": 497,
                "email": "",
                "image": "https://d26o11dgjud8ta.cloudfront.net/profile-image/b8ca0d6f4499404ca67b4dddd421b89f-WhatsAppImage2024-06-30at17.45.12b2010417.jpg",
                "phone_number": "01975991414",
                "last_online": "2025-07-02T13:51:59.108000",
                "online_status": true
            },
            "status": "inquiry",
            "latest_message": {
                "content": "0171699@881",
                "user": {
                    "username": "01626940550_guest",
                    "full_name": "Syedul Hoque",
                    "image": "",
                    "user_id": 4449
                },
                "is_read": false,
                "m_type": "normal",
                "created_at": "2025-07-02T14:17:03.798000"
            },
            "booking_data": {
                "check_in": "2025-05-02",
                "check_out": "2025-05-03",
                "adult": 1,
                "children": 0,
                "infant": 0,
                "pets": 0,
                "total_guest_count": 1
            },
            "listing": {
                "name": "4/2 Economy✔️nonAC 1 room flat 3rd floor @mogbazar",
                "id": 779
            },
            "created_at": "2025-07-02T14:17:03.818000",
            "updated_at": "2025-07-02T14:17:03.818000"
        },
        "unread_message_count": 2
    },
    "meta_info": {
        "count": 12,
        "currentPage": 1,
        "nextPage": null,
        "prevPage": 0,
        "lastPage": 1
    }
}`

`In Chat Room:`  
`{`  
	`"action": "message",`  
	`"message": "im guest 1",`  
	`"conversationId": "6855f59cc476caef2d9d5dd6",`  
	`"user": "670bcc1fd2b57237dc02ebde"`  
`}`

`Read/ seen a message:`  
`Payload:`  
`{`  
	`"action": "is_read",`  
	`"status": true,`  
	`"conversationId": "6855f59cc476caef2d9d5dd6"`  
`}`  
`Response: Global Room`  
`{`  
	`"action": "read_done",`  
	`"room_id": "6855f59cc476caef2d9d5dd6"`  
`}`

`Start a Chat Init:`  
`Payload:`  
	`If a user want chat before buy -> { "action": "inquiry" }`  
	`Chat after buy -> { "action": "confirmed" }`

curl --location 'https://api-chat.stayverz.com/api/v1/chat/user/rooms/?page=1&limit=1000' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdF9uYW1lIjoiU3llZHVsIiwibGFzdF9uYW1lIjoiSG9xdWUiLCJ1c2VybmFtZSI6IjAxNjI2OTQwNTUwX2d1ZXN0IiwidV90eXBlIjoiZ3Vlc3QiLCJwaG9uZV9udW1iZXIiOiIwMTYyNjk0MDU1MCIsImlzX2FjdGl2ZSI6dHJ1ZSwiZXhwIjoxNzUxNDU3MjQzLCJ0b2tlbl90eXBlIjoiYWNjZXNzIn0.IChfO1UaS-23LUyV0_q52rMyyrhy5mm4MSlf0M0pRMQ'
`Response:` `{
    "success": true,
    "message": "Status OK",
    "data": [
        {
            "id": "6814aa522005035b6fe63346",
            "name": "01626940550_guest:01975991414_host",
            "from_user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "to_user": {
                "id": "66816d043d711784032d8a13",
                "username": "01975991414_host",
                "full_name": "MD Asiful Hossain Abid",
                "user_id": 497,
                "email": "",
                "image": "https://d26o11dgjud8ta.cloudfront.net/profile-image/b8ca0d6f4499404ca67b4dddd421b89f-WhatsAppImage2024-06-30at17.45.12b2010417.jpg",
                "phone_number": "01975991414",
                "last_online": "2025-07-02T13:51:59.108000",
                "online_status": true
            },
            "status": "inquiry",
            "latest_message": {
                "content": "hi there",
                "user": {
                    "username": "01626940550_guest",
                    "full_name": "Syedul Hoque",
                    "image": "",
                    "user_id": 4449
                },
                "is_read": false,
                "m_type": "normal",
                "created_at": "2025-07-02T14:13:53.509000"
            },
            "booking_data": {
                "check_in": "2025-05-02",
                "check_out": "2025-05-03",
                "adult": 1,
                "children": 0,
                "infant": 0,
                "pets": 0,
                "total_guest_count": 1
            },
            "listing": {
                "name": "4/2 Economy✔️nonAC 1 room flat 3rd floor @mogbazar",
                "id": 779
            },
            "created_at": "2025-07-02T14:13:53.532000",
            "updated_at": "2025-07-02T14:13:53.532000"
        },
        {
            "id": "6814eae8bffb0a248f43f69a",
            "name": "01626940550_guest:01648063204_host",
            "from_user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "to_user": {
                "id": "672317cbd2b57237dc030f6d",
                "username": "01648063204_host",
                "full_name": "Tariqul Islam",
                "user_id": 1900,
                "email": "",
                "image": "https://d26o11dgjud8ta.cloudfront.net/profile-image/081563edfa1942238c5d10e7a118abe6-1000041927.jpg",
                "phone_number": "01648063204",
                "last_online": "2025-06-03T17:12:25.002000",
                "online_status": false
            },
            "status": "inquiry",
            "latest_message": {
                "content": "Sorry..timely reply dite pari ni",
                "user": {
                    "username": "01648063204_host",
                    "full_name": "Tariqul Islam",
                    "image": "https://d26o11dgjud8ta.cloudfront.net/profile-image/081563edfa1942238c5d10e7a118abe6-1000041927.jpg",
                    "user_id": 1900
                },
                "is_read": false,
                "m_type": "normal",
                "created_at": "2025-05-14T00:50:04.175000"
            },
            "booking_data": {
                "check_in": "2025-05-03",
                "check_out": "2025-05-04",
                "adult": 1,
                "children": 0,
                "infant": 0,
                "pets": 0,
                "total_guest_count": 1
            },
            "listing": {
                "name": "AC private room with non-attached at Banasree J",
                "id": 1390
            },
            "created_at": "2025-05-14T00:50:04.180000",
            "updated_at": "2025-05-14T00:50:04.180000"
        },
        {
            "id": "6814a9bb2005035b6fe6333f",
            "name": "01626940550_guest:01732295392_host",
            "from_user": {
                "id": "67b097034433605e72ba7610",
                "username": "01626940550_guest",
                "full_name": "Syedul Hoque",
                "user_id": 4449,
                "email": "",
                "image": "",
                "phone_number": "01626940550",
                "last_online": "2025-07-02T12:51:46.598000",
                "online_status": true
            },
            "to_user": {
                "id": "6718a1eee072e197b23d4de2",
                "username": "01732295392_host",
                "full_name": "Dipannita ",
                "user_id": 1773,
                "email": "",
                "image": "",
                "phone_number": "01732295392",
                "last_online": "2025-05-30T14:34:02.654000",
                "online_status": false
            },
            "status": "inquiry",
            "latest_message": {
                "content": "Available tonight?",
                "user": {
                    "username": "01626940550_guest",
                    "full_name": "Syedul Hoque",
                    "image": "",
                    "user_id": 4449
                },
                "is_read": true,
                "m_type": "normal",
                "created_at": "2025-05-02T17:17:15.142000"
            },
            "booking_data": {
                "check_in": "2025-05-02",
                "check_out": "2025-05-03",
                "adult": 1,
                "children": 0,
                "infant": 0,
                "pets": 0,
                "total_guest_count": 1
            },
            "listing": {
                "name": "Cozy Private Room At Badda",
                "id": 1479
            },
            "created_at": "2025-05-02T17:17:15.138000",
            "updated_at": "2025-05-02T17:17:15.142000"
        }
    ],
    "extra_data": {
        "all_message_count": 12
    },
    "meta_info": {
        "count": 3,
        "currentPage": 1,
        "nextPage": null,
        "prevPage": 0,
        "lastPage": 1
    }
}`