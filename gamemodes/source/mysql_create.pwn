
stock CreateMysqlTable()
{
    // CREATE TABLE IF NOT EXISTS По логике нужно это использовать. Т.е. проверка на уже имеющиеся таблицы, чтобы не комментить эту хуету

	// pp_bizz
	// Добавлено в TEST + PP1

	// new string_mysql[4084];
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_bizz` ADD `InvType0` INT NOT NULL");
	for(new i = 1; i < 80; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `InvType%d` INT NOT NULL", string_mysql, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_bizz [ InvType ]");
 */
	
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_bizz` ADD `InvPack0` INT NOT NULL");
	for(new i = 1; i < 80; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `InvPack%d` INT NOT NULL", string_mysql, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_bizz [ InvPack ]");
 */
 
    // Добавлено в TEST + PP1
    /*
 	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_bizz` ADD `Product0` INT NOT NULL , ADD `TypeProduct0` INT NOT NULL");
	for(new i = 1; i < MAX_BIZ_ITEM; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `Product%d` INT NOT NULL , ADD `TypeProduct%d` INT NOT NULL", string_mysql, i, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_bizz [ Product, TypeProduct ]");
	*/
	
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_bizz` ADD `OrderType0` INT NOT NULL");
	for(new i = 1; i < 80; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `OrderType%d` INT NOT NULL", string_mysql, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_bizz [ OrderType ]");
 */
	
	// pp_dom
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_dom` ADD `InvType0` INT NOT NULL");
	for(new i = 1; i < 80; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `InvType%d` INT NOT NULL", string_mysql, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_dom [ InvType ]");
 */
	
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_dom` ADD `InvPack0` INT NOT NULL");
	for(new i = 1; i < 80; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `InvPack%d` INT NOT NULL", string_mysql, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_dom [ InvPack ]");
 */
	
	
	// pp_rentwh
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_rentwh` ADD `InvType0` INT NOT NULL , ADD `InvQara0` INT NOT NULL");
	for(new i = 1; i < 20; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `InvType%d` INT NOT NULL , ADD `InvQara%d` INT NOT NULL", string_mysql, i, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_rentwh [ InvType InvQara ]");
 */
	
	
	// pp_organization
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_organization` ADD `InvType0` INT NOT NULL , ADD `InvPara0` INT NOT NULL");
	for(new i = 1; i < 20; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `InvType%d` INT NOT NULL , ADD `InvPara%d` INT NOT NULL", string_mysql, i, i);
	query_empty(pearsq_2, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_organization [ InvType InvPara ]");
 */
	
	
	// pp_igroki
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_igroki` ADD `InvenType1` INT NOT NULL , ADD `InvenPack1` INT NOT NULL");
	for(new i = 2; i < 41; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `InvenType%d` INT NOT NULL , ADD `InvenPack%d` INT NOT NULL", string_mysql, i, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_igroki [ InvenType InvenPack ]");
 */
	
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_igroki` ADD `MarkType0` INT NOT NULL , ADD `MarkPack0` INT NOT NULL");
	for(new i = 1; i < 20; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `MarkType%d` INT NOT NULL , ADD `MarkPack%d` INT NOT NULL", string_mysql, i, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_igroki [ MarkType MarkPack ]");
 */
	/*
	Keyhidden (64) varchar
	- Ability6
	- AbilStat6
	FixInv - временная для перенастройки аккаунтов
	*/
	

	// pp_cars
	// Добавлено в TEST + PP1
 /*
	format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_cars` ADD `InvenType1` INT NOT NULL , ADD `InvenPack1` INT NOT NULL");
	for(new i = 2; i < 21; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `InvenType%d` INT NOT NULL , ADD `InvenPack%d` INT NOT NULL", string_mysql, i, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_cars [ InvenType InvenPack ]");
 */
    /*
    Unixload
    */

	// pp_bizz
	// Добавлено в TEST
	/*format(string_mysql,sizeof(string_mysql),"ALTER TABLE `pp_bizz` ADD `Ware0` INT NOT NULL");
	for(new i = 1; i < MAX_BIZ_ITEM; i++) format(string_mysql,sizeof(string_mysql),"%s , ADD `Ware%d` INT NOT NULL", string_mysql, i);
	query_empty(pearsq, string_mysql);
	printf("[CREATE TABLE]: Добавлены новые таблицы pp_bizz [ Ware ]");
	*/

	// Добавлено в TEST
	//query_empty(pearsq, "ALTER TABLE `pp_bizz` ADD `DeliveryPay` INT NOT NULL");
	 //query_empty(pearsq, "ALTER TABLE `pp_bizz` ADD `OrderStatus` INT NOT NULL");
	return 1;
}


