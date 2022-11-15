/*
=== Romanius's ===============================
       PWN Mail Exploder Plugin Include
================================= v0.2 =======



=== Contacts =================================
=> icq: 4814665
=> email: romanius@list.ru
==============================================
*/

// Defines:

#define PME_SEND_SUCCESS 1
#define PME_INVALID_ADDREES -1
#define PME_SEND_FAILED 0
#define PME_NOT_INITED -2

// Message types:

#define PME_MESSAGE_NORMAL 0
#define PME_MESSAGE_HTML 1

// Functions: 

native SendMail(to[],subject[],messsage[],type=PME_MESSAGE_NORMAL);
native IsValidEmail(email[]);

native PrintPMEInfo();

//======= Visit http://romanius.3dn.ru =======