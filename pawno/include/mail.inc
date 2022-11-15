/*

	Mailer Include By Cameltoe With a lot of help from g_aSlice :))

*/

#include <a_http>

forward MailResponse(index, response_code, data[]);

#define MAX_MAIL_LENGTH 1024

/* Natives
native SendMail(reciever[], sender[], subject[], message[]);
*/


stock SendMail(reciever[], sender[], subject[], message[])
{
	new buffer[512],string[MAX_MAIL_LENGTH];
	EncodeURL(subject, strlen( subject ) + 1); // Thanks to g_aSlice :))
	EncodeURL(message, strlen( message ) + 1); // Thanks to g_aSlice :))
    //format(string, sizeof(string), "desidery.ru/samp-mail.php?sender=%s&reciever=%s&subject=",sender,reciever);
    format(string, sizeof(string), "desidery.ru/samp-mail.php?sender=%s&reciever=%s&subject=%s&message=%s",sender,reciever,subject, message);
    memcpy(buffer,subject,.numbytes = (strlen(subject)+1)*4);
    strcat(string,buffer);
    strcat(string,"&message=");
    memcpy(buffer,message,.numbytes = (strlen(message)+1)*4);
    strcat(string,buffer);
    printf("%s", string);
    HTTP(1, HTTP_GET, string, "", "MailResponse");
}

/*stock SendMail(reciever[], sender[], subject[], message[])
{
	new string[MAX_MAIL_LENGTH];
	EncodeURL(subject, strlen( subject ) + 1); // Thanks to g_aSlice :))
	EncodeURL(message, strlen( message ) + 1); // Thanks to g_aSlice :))
	format(string, sizeof(string), "nordicroleplay.tk/test/test/index.php?sender=%s&reciever=%s&subject=%s&message=%s",sender,reciever,subject, message);
	printf("%s", string);
	HTTP(1, HTTP_GET, string, "", "MailResponse");
}*/

public MailResponse(index, response_code, data[])
{
	return 1;
}

stock EncodeURL( szString[ ], iSize = sizeof( szString ) ) // Thanks to g_aSlice :))
{
    for ( new i = 0, l = strlen( szString ); i < l; i++ )
    {
        switch ( szString[ i ] )
        {
            case '!', '(', ')', '\'', '*',
                 '0' .. '9',
                 'A' .. 'Z',
                 'a' .. 'z':
            {
                continue;
            }

            case ' ':
            {
                szString[ i ] = '+';

                continue;
            }
        }

        new
            s_szHex[ 8 ]
        ;

        if ( i + 3 >= iSize )
        {
            szString[ i ] = EOS;

            break;
        }

        if ( l + 3 >= iSize )
            szString[ iSize - 3 ] = EOS;

        format( s_szHex, sizeof( s_szHex ), "%02h", szString[ i ] );

        szString[ i ] = '%';

        strins( szString, s_szHex, i + 1, iSize );

        l += 2;
        i += 2;

        if ( l > iSize - 1 )
            l = iSize - 1;
    }
}