#include <a_http>

#if !defined Function
	#define Function::%0(%1)    %0(%1); public %0(%1)
#endif
Function::SendMail(Email[],Assunto[],Remetente[],Mensagem[])
{
    new Link[1200];
    format(Link,sizeof(Link),"pears-project.ru/mailer.php?Email=%s&Assunto=%s&From=%s&Mensagem=%s",Email,Assunto,Remetente,Mensagem);
    for(new c; c < strlen(Link)+1; c++)
    {
         if(Link[c] == ' ') Link[c] = '+';
    }
    HTTP(0, HTTP_POST, Link, "", "");
    return 1;
}