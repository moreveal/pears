new hankActor = -1;
new Float: hankPosition[] = {1630.7745, -1848.4137, 13.5381};

stock Hank_LoadActor() {
    if (hankActor == -1) {
        hankActor = CreateDynamicActor(30, hankPosition[0], hankPosition[1], hankPosition[2], 0.0, true, 100.0, 0);
        CreateDynamic3DTextLabel("{777777}Хэнк {FF9000}[ALT]", 0xA9C4E4FF, hankPosition[0], hankPosition[1], hankPosition[2], 5.0, .worldid = 0, .interiorid = 0);
    }
    return 1;
}