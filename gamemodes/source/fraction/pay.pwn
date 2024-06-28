
new minOrgSalary[] = // Минимальная зп в организации (на 1 ранге)
{
    0,
    3000, // SAPD
    3000, // FBI
    3000, // NGSA
    3000, // ASGH
    2000, // Cosa Nostra
    2000, // Yakuza
    3000, // Government
    2000, // ICA
    3000, // CNN
    2000, // Triada
    2000, // 
    2000, // RM
    2000, // Grove
    2000, // Ballas
    2000, // Vagos
    2000, // Los Aztecas
    2000, //
    2000 // Arabian
};

new maxOrgSalary[] = // Максимальная зп в организации
{
    0,
    30000, // SAPD
    30000, // FBI
    30000, // NGSA
    30000, // ASGH
    20000, // Cosa Nostra
    20000, // Yakuza
    30000, // Government
    20000, // ICA
    20000, // CNN
    20000, // Triada
    10000, // 
    20000, // RM
    20000, // Grove
    20000, // Ballas
    20000, // Vagos
    20000, // Los Aztecas
    10000, //
    20000 // Arabian
};


// Функция для расчета зарплаты по рангу
stock GetSalary(rank, org)
{
    new max_rank = get_maxrank(org);

    if (rank < 1) rank = 1;
    if (rank > max_rank) rank = max_rank;

    // Линейная интерполяция зарплаты
    new Float:ratio = float(rank - 1) / (max_rank - 1);
    new Float:salary = OrganInfo[org][gMinSalary] + (OrganInfo[org][gMaxSalary] - OrganInfo[org][gMinSalary]) * ratio;
    return floatround(salary, floatround_round);
}

stock LoadSalaryOrganization(org)
{
    if(org >= sizeof(minOrgSalary)) return false;

    OrganInfo[org][gMinSalary] = minOrgSalary[org];
    OrganInfo[org][gMaxSalary] = maxOrgSalary[org];
    return true;
}
