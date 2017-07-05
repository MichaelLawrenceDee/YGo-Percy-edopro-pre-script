--Anime Archtype
function c420.initial_effect(c)
	--1st parameter = card, 2nd parameter = IsFusion
end

-- Alligator 
-- アリゲーター 
-- Graydle Alligator/Spawn Alligator/Toon Alligator/Lion Alligator
c420.OCGAlligator={
	39984786,4611269,59383041,66451379
}
function Card.IsAlligator(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x502) or c:IsFusionCode(table.unpack(c420.OCGAlligator))
	else
		return c:IsSetCard(0x502) or c:IsCode(table.unpack(c420.OCGAlligator))
	end
end

-- Angel (archetype) list to update
-- 天使
-- てんし
-- Injection Fairy Lily/Machine Angel Ritual/Mechquipped Angineer
-- Ghostrick Angel of Mischief/Doma The Angel of Silence/Angel of Zera
-- Winged Egg of New Life/Archlord Kristya/Archlord Zerato
-- Rosaria, the Stately Fallen Angel/Harvest Angel of Wisdom/Soul of the Pure
-- Soul of the Pure/Graceful Dice/Fairy's Hand Mirror
-- Graceful Tear/Graceful Charity/Numinous Healer
-- Fallen Angel of Roses/Muse-A/Queen Angel of Roses
c420.OCGAngel={
	79575620,39996157,15914410,53334641,16972957,42216237,
	42418084,18378582,59509952,81146288,85399281,47852924,
	74137509,17653779,9032529,79571449,2130625,49674183,
	69992868,96470883
}
function Card.IsAngel(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x154a) or c:IsFusionCode(table.unpack(c420.OCGAngel)) or c:IsFusionSetCard(0xef)
	else
		return c:IsSetCard(0x154a) or c:IsCode(table.unpack(c420.OCGAngel)) or c:IsSetCard(0xef)
	end
end

-- Anti アンチ 
-- Dystopia the Despondent/Delta Crow - Anti Reverse
function Card.IsAnti(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x503) or c:IsFusionCode(52085072,59839761)
	else
		return c:IsSetCard(0x503) or c:IsCode(52085072,59839761)
	end
end

-- Assassin アサシン 
-- Ansatsu/Dark Hunter/Night Assailant
-- Night Papilloperative/Gravekeeper's Assailant/Photon Papilloperative
-- Raiden, Hand of the Lightsworn
c420.OCGAssassin={
	48365709,19357125,16226786,
	2191144,25262697,28150174,
	77558536
}
function Card.IsAssassin(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x504) or c:IsFusionCode(table.unpack(c420.OCGAssassin))
	else
		return c:IsSetCard(0x504) or c:IsCode(table.unpack(c420.OCGAssassin))
	end
end

-- Astral アストラル 
-- Astral Barrier/Astral Barrier
function Card.IsAstral(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x505) or c:IsFusionCode(37053871,45950291)
	else
		return c:IsSetCard(0x505) or c:IsCode(37053871,45950291)
	end
end

-- Atlandis アトランタル
-- Number C6: Chronomaly Chaos Atlandis/Number 6: Chronomaly Atlandis
function Card.IsAtlandis(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x506) or c:IsFusionCode(9161357,6387204)
	else
		return c:IsSetCard(0x506) or c:IsCode(9161357,6387204)
	end
end

-- Barian (archetype) バリアン
-- CXyz Barian Hope
function Card.IsBarian(c,fbool)
	if c:IsBarians(fbool) or c:IsBattleguard(fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x509) or c:IsFusionCode(67926903)
	else
		return c:IsSetCard(0x509) or c:IsCode(67926903)
	end
end

-- Barian's バリアンズ
-- Rank-Up-Magic Barian's Force, Rank-Up-Magic Limited Barian's Force
function Card.IsBarians(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x1509) or c:IsFusionCode(47660516,92365601)
	else
		return c:IsSetCard(0x1509) or c:IsCode(47660516,92365601)
	end
end

-- Battleguard バーバリアン
c420.OCGBattleguard={
	-- Battleguard King, Lava Battleguard, Swamp Battleguard
	-- Battleguard Howling, Battleguard Rage
	39389320,20394040,40453765,78621186,42233477
}
function Card.IsBattleguard(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x2509) or c:IsFusionCode(table.unpack(c420.OCGBattleguard))
	else
		return c:IsSetCard(0x2509) or c:IsCode(table.unpack(c420.OCGBattleguard))
	end
end

-- Blackwing Tamer 
-- ＢＦＴ
-- ブラックフェザーテイマー
-- Blackwing Tamer - Obsidian Hawk Joe
function Card.IsBlackwingTamer(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x2033) or c:IsFusionCode(81983656)
	else
		return c:IsSetCard(0x2033) or c:IsCode(81983656)
	end
end

-- Butterfly (list to do)
-- 蝶
-- ちょう
-- Blazewing Butterfly/Flower Cardian Boardefly/Flower Cardian Peony with Butterfly
-- Butterfly Dagger - Elma
c420.OCGButterfly={
	
}
function Card.IsButterfly(c,fbool)
	if c:IsPhantomButterfly(fbool) or c:IsButterspy(fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x50c) or c:IsFusionCode(table.unpack(c420.OCGButterfly))
	else
		return c:IsSetCard(0x50c) or c:IsCode(table.unpack(c420.OCGButterfly))
	end
end

-- Phantom Butterfly (list to do)
-- 幻蝶
-- げんちょう
-- Butterspy Protection
c420.OCGPhantomButterfly={
	
}
function Card.IsPhantomButterfly(c,fbool)
	if c:IsButterspy(fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x150c) or c:IsFusionCode(table.unpack(c420.OCGPhantomButterfly))
	else
		return c:IsSetCard(0x150c) or c:IsCode(table.unpack(c420.OCGPhantomButterfly))
	end
end
-- Butterspy (list to do)
-- 幻蝶の刺客
-- げんちょうのしきゃく
-- Swallowtail Butterspy/Blue Mountain Butterspy/Morpho Butterspy
c420.OCGButterspy={
	
}
function Card.IsButterspy(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x350c) or c:IsFusionCode(table.unpack(c420.OCGButterspy))
	else
		return c:IsSetCard(0x350c) or c:IsCode(table.unpack(c420.OCGButterspy))
	end
end

-- C (archetype)
-- Ｃ 
-- カオス 
-- is "C" or Cxyz or Cnumber
function Card.IsC(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x1048) or c:IsFusionSetCard(0x1073) or c:IsFusionSetCard(0x568)
	else
		return c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsSetCard(0x568)
	end
end

-- Cat キャット (list to update)
-- Cat Shark/Nekogal #2/Mimicat
-- Fluffal Cat/Crystal Beast Amethyst Cat/Majespecter Cat - Nekomata
-- Magicat/Catnipped Kitty/Lunalight Cat Dancer
-- Lunalight Blue Cat/Rescue Cat/Lock Cat
c420.OCGCat={
	84224627,43352213,88032456,2729285,32933942,5506791,
	25531465,96501677,51777272,11439455,14878871,52346240
}
function Card.IsCat(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x50e) or c:IsFusionCode(table.unpack(c420.OCGCat))
	else
		return c:IsSetCard(0x50e) or c:IsCode(table.unpack(c420.OCGCat))
	end
end

-- Celestial 
-- 天輪
-- てんりん
-- Celestial Double Star Shaman/Guiding Light
function Card.IsCelestial(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x254a) or c:IsFusionCode(69865139,25472513)
	else
		return c:IsSetCard(0x254a) or c:IsCode(69865139,25472513)
	end
end

-- Champion 
-- 王者
-- おうじゃ
-- Champion's Vigilance
function Card.IsChampion(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x152f) or c:IsFusionCode(82382815)
	else
		return c:IsSetCard(0x152f) or c:IsCode(82382815)
	end
end
-- Clear クリアー
-- Clear Vice Dragon/Clear World
function Card.IsClear(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x510) or c:IsFusionCode(97811903,82044279,33900648)
	else
		return c:IsSetCard(0x510) or c:IsCode(97811903,82044279,33900648)
	end
end

-- Comics Hero 
-- ＣＨ
-- コミックヒーロー
-- CXyz Comics Hero Legend Arthur/Comics Hero King Arthur
function Card.IsComicsHero(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x511) or c:IsFusionCode(77631175,13030280)
	else
		return c:IsSetCard(0x511) or c:IsCode(77631175,13030280)
	end
end

-- Cubic Seed 
-- 方界胤
-- ほうかいいん 
-- Vijam the cubic seed
function Card.IsCubicSeed(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x10e3) or c:IsFusionCode(15610297)
	else
		return c:IsSetCard(0x10e3) or c:IsCode(15610297)
	end
end

-- Dart ダーツ
-- Fire Darts
function Card.IsDart(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x513) or c:IsFusionCode(43061293)
	else
		return c:IsSetCard(0x513) or c:IsCode(43061293)
	end
end

-- Dice (archetype) ダイス 
-- Speedroid Red-Eyed Dice/Speedroid Tri-Eyed Dice/Dice Armadillo
-- Dice Try!/Dice Jar/Dice Roll Battle
-- Dice Re-Roll
c420.OCGDice={
	16725505,27660735,69893315,59905358,3549275,88482761,
	83241722
}
function Card.IsDice(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x514) or c:IsFusionCode(table.unpack(c420.OCGDice))
	else
		return c:IsSetCard(0x514) or c:IsCode(table.unpack(c420.OCGDice))
	end
end
-- Dog ドッグ 
-- Assault Dog/Mad Dog of Darkness/Ancient Gear Hunting Hound
-- Performapal Bubblebowwow/Alien Dog/Guard Dog
-- Kozmo DOG Fighter/Skull Dog Marron/Wind-Up Dog
-- Chain Dog/Nin-Ken Dog/Watch Dog
-- Fluffal Dog/Flamvell Firedog/Wroughtweiler
-- Magidog/Mecha-Dog Marron
c420.OCGDog={
	72714226,79182538,42878636,34379489,15475415,57346400,
	29491334,86652646,12076263,96930127,11987744,86889202,
	39246582,23297235,6480253,47929865,94667532
}
function Card.IsDog(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x516) or c:IsFusionCode(table.unpack(c420.OCGDog))
	else
		return c:IsSetCard(0x516) or c:IsCode(table.unpack(c420.OCGDog))
	end
end

-- Doll ドール
-- Aqua Madoor/Tribute Doll/Malice Doll of Demise
-- Neo Aqua Madoor/Rogue Doll/Lightray Madoor
-- Gimmick Puppet Dreary Doll/Gimmick Puppet Magnet Doll
c420.OCGDoll={
	72657739,91939608,85639257,2903036,49563947,82579942,92418590,39806198
}
function Card.IsDoll(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x517) or c:IsFusionSetCard(0x9d) or c:IsFusionCode(table.unpack(c420.OCGDoll))
	else
		return c:IsSetCard(0x517) or c:IsSetCard(0x9d) or c:IsCode(table.unpack(c420.OCGDoll))
	end
end

-- Druid ドルイド 
-- Secret Sect Druid Wid/Secret Sect Druid Dru/Aurkus, Lightsworn Druid
c420.OCGDruid={
	24062258,97064649,7183277
}
function Card.IsDruid(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x8c) or c:IsFusionCode(table.unpack(c420.OCGDruid))
	else
		return c:IsSetCard(0x8c) or c:IsCode(table.unpack(c420.OCGDruid))
	end
end

-- Dyson ダイソン 
-- Number C9: Chaos Dyson Sphere/Number 9: Dyson Sphere
function Card.IsDyson(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x519) or c:IsFusionCode(1992816,32559361)
	else
		return c:IsSetCard(0x519) or c:IsCode(1992816,32559361)
	end
end

-- Earth (archetype) (to do)
-- 地
-- じ
c420.OCGEarth={
	42685062,76052811,71564150,77827521,75375465,70595331,
	94773007,45042329
}
function Card.IsEarth(c,fbool)
	if c:IsEarthbound(fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x51a) or c:IsFusionCode(table.unpack(c420.OCGEarth))
	else
		return c:IsSetCard(0x51a) or c:IsCode(table.unpack(c420.OCGEarth))
	end
end

-- Earthbound (list to update)
-- 地縛
-- じばく 
-- Earthbound Revival/Roar of the Earthbound/Earthbound Whirlwind
-- Earthbound Linewalker/Call of the Earthbound
c420.OCGEarthbound={
	64187086,56339050,96907086,67987302,65743242
}
function Card.IsEarthbound(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x151a) or c:IsFusionSetCard(0x21) or c:IsFusionCode(67105242,67987302)
	else
		return c:IsSetCard(0x151a) or c:IsSetCard(0x21) or c:IsCode(67105242,67987302)
	end
end

-- Elf エルフ 
-- Ghost Fairy Elfobia/Wing Egg Elf/Ancient Elf
-- Kozmoll Dark Lady/Shining Elf/Mystical Fairy Elfuria
-- Prediction Princess Petalelf/Dancing Elf/Dark Elf
-- Gemini Elf/Toon Gemini Elf/Flelf
-- Blackwing - Elphin the Raven/Mystical Elf/Gift of The Mystical Elf
c420.OCGElf={
	44663232,98582704,39897277,93221206,97170107,85239662,
	68625727,59983499,21417692,69140098,42386471,61807040,
	11613567,15025844,98299011
}
function Card.IsElf(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x51b) or c:IsFusionSetCard(0xe4) or c:IsFusionCode(table.unpack(c420.OCGElf))
	else
		return c:IsSetCard(0x51b) or c:IsSetCard(0xe4) or c:IsCode(table.unpack(c420.OCGElf))
	end
end

-- Emissary of Darkness 
-- 冥府の使者
-- めいふのししゃ
-- Gorz the Emissary of Darkness/Emissary of Darkness Token
function Card.IsEmissaryOfDarkness(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x51c) or c:IsFusionCode(44330098,44330099)
	else
		return c:IsSetCard(0x51c) or c:IsCode(44330098,44330099)
	end
end

-- Fairy (archetype) フェアリー
-- Ancient Fairy Dragon/CXyz Dark Fairy Cheer Girl/Nekogal #1
-- Dancing Fairy/Fairy Archer/Fairy Cheer Girl
-- Fairy Tail - Luna/Fairy Tail - Snow/Fairy Tail - Rella
-- Fairy Tail - Sleeper/Fairy Dragon/Little Fairy
-- Woodland Sprite

c420.OCGFairy={
	51960178,25862681,23454876,90925163,48742406,51960178,
	45939611,20315854,1761063,6979239,55623480,42921475
}
function Card.IsFairy(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x51d) or c:IsFusionCode(table.unpack(c420.OCGFairy))
	else
		return c:IsSetCard(0x51d) or c:IsCode(table.unpack(c420.OCGFairy))
	end
end

-- Forest (archetype) 
-- 森
-- もり 
-- Ancient Forest/Witch of the Black Forest/Naturia Forest
-- Forest/Yellow Baboon, Archer of the Forest/Murmur of the Forest
-- Wood Remains/Wodan the Resident of the Forest/Alpacaribou, Mystical Beast of the Forest
-- Valerifawn, Mystical Beast of the Forest/Kalantosa, Mystical Beast of the Forest/Uniflora, Mystical Beast of the Forest
-- Eco, Mystical Spirit of the Forest/Green Baboon, Defender of the Forest
c420.OCGForest={
	
}
function Card.IsForest(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x51f) or c:IsFusionCode(table.unpack(c420.OCGForest))
	else
		return c:IsSetCard(0x51f) or c:IsCode(table.unpack(c420.OCGForest))
	end
end

-- Fossil (not finished) 
-- 化石
-- かせき
-- Release from Stone/Fossil Dig/Fossil Excavation
c420.OCGFossil={
	
}
function Card.IsFossil(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x512) or c:IsFusionCode(table.unpack(c420.OCGFossil))
	else
		return c:IsSetCard(0x512) or c:IsCode(table.unpack(c420.OCGFossil))
	end
end

-- Gem-Knight Lady ジェムナイトレディ 
-- Gem-Knight Lady Brilliant Diamond/Gem-Knight Lady Lapis Lazuli
function Card.IsGemKnightLady(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x3047) or c:IsFusionCode(47611119,19355597)
	else
		return c:IsSetCard(0x3047) or c:IsCode(47611119,19355597)
	end
end

-- Gorgonic
-- ゴルゴニック 
-- Gorgonic Gargoyle/Gorgonic Guardian/Gorgonic Ghoul
-- Gorgonic Cerberus/Gorgonic Golem
c420.OCGGorgonic={
	64379261,84401683,98637386,37168514,90764875
}
function Card.IsGorgonic(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x522) or c:IsFusionCode(table.unpack(c420.OCGGorgonic))
	else
		return c:IsSetCard(0x522) or c:IsCode(table.unpack(c420.OCGGorgonic))
	end
end
-- Goyo ゴヨウ 
-- Brotherhood of the Fire Fist - Coyote/Goyo Emperor/Goyo Guardian
-- Goyo King/Goyo Chaser/Goyo Defender
-- Goyo Predator
c420.OCGGoyo={
	49785720,59255742,7391448,84305651,63364266,58901502,
	98637386
}
function Card.IsGoyo(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x523) or c:IsFusionCode(table.unpack(c420.OCGGoyo))
	else
		return c:IsSetCard(0x523) or c:IsCode(table.unpack(c420.OCGGoyo))
	end
end

-- Granel
-- グランエル
function Card.IsGranel(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x524) or c:IsFusionCode(2137678,4545683)
	else
		return c:IsSetCard(0x524) or c:IsCode(2137678,4545683)
	end
end

-- Hand (archetype) ハンド
-- Ice Hand/Ancient Gear Fist/Performapal Sleight Hand Magician
-- Number C106: Giant Red Hand/Koa'ki Meiru Powerhand/Comic Hand
-- Kaminote Blow/The Judgement Hand/Number 106: Giant Hand
-- Phantom Hand/Fire Hand/Prominence Hand
-- Magic Hand/Rocket Hand/Hundred Eyes Dragon
c420.OCGHand={
	28003512,52800428,62793020,68535320,95929069,22530212,
	21414674,63746411,55888045
}
function Card.IsHand(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x527) or c:IsFusionCode(table.unpack(c420.OCGHand))
	else
		return c:IsSetCard(0x527) or c:IsCode(table.unpack(c420.OCGHand))
	end
end

-- Heavy Industry 
-- 重機
-- じゅうき 
-- Digvorzhak, King of Heavy Industry/Heavy Freight Train Derricrane/Jumbo Drill
c420.OCGHeavyIndustry={
	42851643,29515122,13647631
}
function Card.IsHeavyIndustry(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x529) or c:IsFusionCode(table.unpack(c420.IsHeavyIndustry))
	else
		return c:IsSetCard(0x529) or c:IsCode(table.unpack(c420.IsHeavyIndustry))
	end
end

-- Hell 
-- 地獄
-- ヘル 
-- Hundred-Footed Horror/Chthonian Soldier/Helpoemer/Mefist the Infernal General
c420.OCGHell={
	36029076,76052811,46820049,50916353
}
function Card.IsHell(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x567) or c:IsFusionCode(table.unpack(c420.OCGHell))
	else
		return c:IsSetCard(0x567) or c:IsCode(table.unpack(c420.OCGHell))
	end
end

-- Heraldic 
-- 紋章
-- もんしょう
-- Number 8: Heraldic King Genom-Heritage/Number 18: Heraldry Patriarch/Medallion of the Ice Barrier
function Card.IsHeraldic(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x566) or c:IsFusionSetCard(0x76) or c:IsFusionCode(23649496,47387961)
	else
		return c:IsSetCard(0x566) or c:IsSetCard(0x76) or c:IsCode(23649496,47387961)
	end
end


-- Hunder サンダー 
-- Ally of Justice Thunder Armor/Evilswarm Thunderbird/Elemental HERO Thunder Giant
-- Mahunder/Pahunder/Brohunder
-- Sishunder/Phantom Beast Thunder-Pegasus/Thunder End Dragon
-- Thunder Crash/Thunder Short/Thunder Sea Horse
-- Thunder Dragon/Raigeki Break/Raigeki Bottle
-- Raigeki/Thunder Unicorn/Twin-Headed Thunder Dragon
-- D/D/D Gust King Alexander/D/D/D Gust High King Alexander/Number 91: Thunder Spark Dragon
-- Thunder Kid/Black Thunder/Blizzard Thunderbird/Blue Thunder T-45
-- Mega Thunderball/Thunder King, the Lightningstrike Kaiju
c420.OCGHunder={
	
}
function Card.IsHunder(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x565) or c:IsFusionCode(table.unpack(c420.OCGHunder))
	else
		return c:IsSetCard(0x565) or c:IsCode(table.unpack(c420.OCGHunder))
	end
end

-- Inu (list to do) 犬
-- Mad Dog of Darkness/Ancient Gear Hunting Hound/Caninetaur
-- Skull Dog Marron/Nin-Ken Dog/Watch Dog
-- Zombowwow/Doomdog Octhros/Outstanding Dog Marron
-- Mecha-Dog Marron/Yokotuner
c420.OCGInu={
	
}
function Card.IsInu(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x52a) or c:IsFusionCode(table.unpack(c420.OCGInu))
	else
		return c:IsSetCard(0x52a) or c:IsCode(table.unpack(c420.OCGInu))
	end
end

-- Ivy アイヴィ 
-- Wall of Ivy/Ivy Shackles/Ivy Token
c420.OCGIvy={
	30069398,14730606,30069399
}
function Card.IsIvy(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x52b) or c:IsFusionCode(table.unpack(c420.OCGIvy))
	else
		return c:IsSetCard(0x52b) or c:IsCode(table.unpack(c420.OCGIvy))
	end
end

-- Jester ジェスター 
-- Majester Paladin, the Ascending Dracoslayer/Jester Confit/Jester Lord
c420.OCGJester={
	72992744,8487449,88722973,
}
function Card.IsJester(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x52c) or c:IsFusionCode(table.unpack(c420.OCGJester))
	else
		return c:IsSetCard(0x52c) or c:IsCode(table.unpack(c420.OCGJester))
	end
end

-- Jutte ジュッテ
-- Jutte Fighter
function Card.IsJutte(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x52d) or c:IsFusionCode(60410769)
	else
		return c:IsSetCard(0x52d) or c:IsCode(60410769)
	end
end

-- King (not finished) 
-- 王
-- おう
-- Brron, Mad King of Dark World/The Furious Sea King/Zeman the Ape King
-- Hot Red Dragon Archfiend King Calamity/Royal Decree
-- Royal Decree/Royal Decree/Royal Writ of Taxation
-- Royal Oppression/Imperial Order/Imperial Iron Wall
-- Royal Prison/Royal Tribute/Pharaoh's Treasure
-- Pharaonic Protector/Temple of the Kings/Necrovalley
-- Curse of Royal/King Tiger Wanghu/King's Consonance
-- King's Consonance/Protector of the Throne/Invader of the Throne
-- Guardian of the Throne Room/Trial of the Princesses
-- Royal Keeper/Trap of the Imperial Tomb/Royal Magical Library
-- Brotherhood of the Fire Fist - Tiger King/Gash the Dust Lord
-- Number C65: King Overfiend/The Twin Kings, Founders of the Empire/Machine King
-- Machine King - 3000 B.C./Machine King Prototype/Magical King Moonstar
-- Barbaroid, the Ultimate Battle Machine/Unformed Void/Amorphactor Pain, the Imagination Dracoverlord
-- Phantom King Hydride/Gazelle the King of Mythical Beasts/Queen of Autumn Leaves
-- Ice Queen/Pumpking the King of Ghosts/Lich Lord, King of the Underworld
-- King Pyron/Demise, King of Armageddon
-- Dark King of the Abyss/Abyssal Kingshark/Machine Lord Ür
-- Alector, Sovereign of Birds/Beast King Barbaros/Leo, the Keeper of the Sacred Tree
-- Sacred Noble Knight of King Artorigus/Endymion, the Master Magician/Digvorzhak, King of Heavy Industry
-- Beast Machine King Barbaros Ür/Queen's Bodyguard/Queen's Bodyguard
-- Queen's Pawn/Skull Archfiend of Lightning/Emperor of the Land and Sea
-- Artorigus, King of the Noble Knights/Gwenhwyfar, Queen of Noble Arms/Hieratic Dragon King of Atum
-- Absolute King Back Jack/Big Eye/Superancient Deepsea King Coelacanth
-- Super Quantal Mech King Great Magnus/Princess of Tsurugi
-- Shinato, King of a Higher Plane/Dark Highlander/Celestial Wolf Lord, Blue Sirius
-- D/D/D Destiny King Zero Laplace
-- D/D/D Oblivion King Abyss Ragnarok
-- D/D/D Chaos King Apocalypse
-- D/D/D Dragonbane King Beowulf
-- D/D/D Doom King Armageddon
-- D/D/D Gust High King Executive Alexander
-- D/D/D Oracle King d'Arc
-- D/D/D Cursed King Siegfried
-- D/D/D Supreme King Kaiser
-- D/D/D Duo-Dawn King Kali Yuga
-- D/D/D Marksman King Tell
-- D/D/D Superdoom King Purplish Armageddon
-- D/D/D Wave King Caesar
-- D/D/D Wave Oblivion King Caesar Ragnarok
-- D/D/D Wave High King Executive Caesar
-- D/D/D Dragon King Pendragon
-- D/D/D Rebel King Leonidas
-- D/D/D Stone King Darius
-- D/D/D Flame King Genghis
-- D/D/D Flame High King Executive Genghis
-- D/D/D Gust King Alexander
-- Vennominon the King of Poisonous Snakes/Number 8: Heraldic King Genom-Heritage/Rise to Full Height
-- King of the Swamp/Beastking of the Swamps/Imperial Tombs of Necrovalley
-- Coach King Giantrainer/Coach Captain Bearman

-- archtype:Fire King/Supreme King/Monarch (spell/trap)
c420.OCGKing={
	
}
function Card.IsKing(c,fbool)
	if Card.IsChampion(c,fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x52f) or c:IsFusionCode(table.unpack(c420.OCGKing))
	else
		return c:IsSetCard(0x52f) or c:IsCode(table.unpack(c420.OCGKing))
	end
end

-- Knight (not finished) ナイト 
-- Arcana Knight Joker/Dark Titan of Terror/Ancient Gear Knight
-- Arma Knight/Arcanite Magician/ Arcanite Magician/Assault Mode
-- D.D. Unicorn Knight/Insect Knight/Infernity Knight
-- Evilswarm Nightmare/Serpent Night Dragon/Elemental HERO Neos Knight
-- Airknight Parshath/Alien Ammonite/Ojama Knight
-- Chronomaly Gordian Knot/Number C101: Silent Honor DARK/Kagemucha Knight
-- Ganbara Knight/King's Knight/Gimmick Puppet Twilight Joker
-- Gimmick Puppet Nightmare/Galaxy Knight/King's Knight
-- Quick-Span Knight/Mirage Knight/Koa'ki Meiru Urnight
-- Cockroach Knight/Dark Flare Knight/Copy Knight
-- Command Knight/Ghostrick Night/Cipher Mirror Knight
-- Succubus Knight/Big Belly Knight/Shine Knight
-- Shadowknight Archfiend/Doomcaliber Knight/Night Express Knight
-- Jade Knight/Jack's Knight/Jutte Fighter
-- Skull Knight #2/Zubaba Knight/Divine Knight Ishzark
-- Wind-Up Knight/Tasuke Knight/Tatakawa Knight
-- Gaia Knight, the Force of Earth/XX-Saber Fulhelmknight/XX-Saber Boggart Knight
-- D/D Nighthowl/Toy Knight/Dragunity Knight - Vajrayana
-- Dragunity Knight - Gae Dearg/Dragunity Knight - Gae Bulg/Dragunity Knight - Trident
-- Dragunity Knight - Barcha/Dragonic Knight/Night Assailant
-- Night's End Sorcerer/Paladin of Photon Dragon/Paladin of Dark Dragon
-- Paladin of White Dragon/Night Beam/Knight Day Grepher
-- Night Dragolich/Night Papilloperative/Nightmare Scorpion
-- Theban Nightmare/Nightmare Archfiends/Nightmare Horse
-- Reaper on the Nightmare/Night Lizard/Twilight Rose Knight
-- Number 101: Silent Honor ARK/Number 47: Nightmare Shark/
-- Supreme Arcanite Magician/Valkyrian Knight/Royal Knight of the Ice Barrier
-- Vivid Knight/Pixie Knight/Familiar Knight
-- Paladin of the Cursed Dragon/Dark Magician Knight/Blade Knight
-- Penguin Knight/Nightmare Penguin/Seiyaryu/Avenging Knight Parshath
-- Dragon Master Knight/Mermaid Knight/Midnight Fiend
-- Super Roboyarou,Red-Eyes Metal Knight Gearfried

-- TellarKnight/Igknight/Gem-Knight
c420.OCGKnight={
	24435369,83678433,1412158,85651167,89494469,39303359,36151751,14553285,95291684,35052053,
	71341529,66516792,18036057,652362,72837335,19353570,24291651,64788463,92821268,55204071,
	35950025,11287364,49217579,30936186,33413638,21843307,10375182,85827713,58383100,62873545,
	55291359,32696942,86952477,9603356,78700060,51126152,44364207,90876561,60410769,15653824,
	97896503,57902462,80538728,86039057,18444902,78422252,5998840,48210156,1826676,38109772,
	16226786,36107810,85346853,71408082,73398797,89882100,15767889,88724332,88643173,51838385,
	42956963,59290628,78402798,6150044,31924889,359563,72926163,40391316,12744567,97204936,
	21249921,34116027,900787,80159717,25682811,2191144,85684223,48739166,2986553,31320433,
	99348756,66661678,52575195,35429292,89731911,68670547,50725996,39507162,36039163,81306586,
	6740720,69514125
}
function Card.IsKnight(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x530) or c:IsFusionSetCard(0x1047) or c:IsFusionSetCard(0x9c) or c:IsFusionSetCard(0xc8) 
			or c:IsFusionCode(table.unpack(c420.OCGKnight))
	else
		return c:IsSetCard(0x530) or c:IsSetCard(0x1047) or c:IsSetCard(0x9c) or c:IsSetCard(0xc8) or c:IsCode(table.unpack(c420.OCGKnight))
	end
end

-- Koala コアラ 
c420.OCGKoala={
	-- Big Koala, Des Koala, Vampire Koala, Sea Koala, Koalo-Koala, Tree Otter
	42129512,69579761,1371589,87685879,7243511,71759912,
}
function Card.IsKoala(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x531) or c:IsFusionCode(table.unpack(c420.OCGKoala))
	else
		return c:IsSetCard(0x531) or c:IsCode(table.unpack(c420.OCGKoala))
	end
end

-- Lamp ランプ 
-- Performapal Trump Witch/Performapal Trump Girl/Mech Mole Zombie
-- Ancient Lamp/Mystic Lamp/Lord of the Lamp
-- La Jinn the Mystical Genie of the Lamp
c420.OCGLamp={
	54912977,97590747,98049915,99510761,91584698,42002073,
	63545455
}
function Card.IsLamp(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x532) or c:IsFusionCode(table.unpack(c420.OCGLamp))
	else
		return c:IsSetCard(0x532) or c:IsCode(table.unpack(c420.OCGLamp))
	end
end

-- Landstar ランドスター 
-- Comrade Swordsman of Landstar/Swordsman of Landstar
function Card.IsLandstar(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x533) or c:IsFusionCode(3573512,83602069)
	else
		return c:IsSetCard(0x533)  or c:IsCode(3573512,83602069)
	end
end

-- Line Monster ラインモンスター 
-- Number 72: Shogi Rook/Shogi Knight/Shogi Lance
c420.OCGLineMonster={
	32476434,41493640,75253697
}
function Card.IsLineMonster(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x564) or c:IsFusionCode(table.unpack(c420.OCGLineMonster))
	else
		return c:IsSetCard(0x564) or c:IsCode(table.unpack(c420.OCGLineMonster))
	end
end

-- Magnet 
-- 磁石
-- マグネット
function Card.IsMagnet(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x534) or c:IsFusionSetCard(0x2066)
	else
		return c:IsSetCard(0x534) or c:IsSetCard(0x2066)
	end
end

-- Mantis カマキリ
-- Empress Mantis
function Card.IsMantis(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x535) or c:IsFusionCode(58818411)
	else
		return c:IsSetCard(0x535) or c:IsCode(58818411)
	end
end

-- Melodious Songstress 
-- 幻奏の歌姫
-- げんそうのうたひめ
-- Soprano the Melodious Songstress/Solo the Melodious Songstress
function Card.IsMelodiousSongtress(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x209b) or c:IsFusionCode(14763299,62895219)
	else
		return c:IsSetCard(0x209b) or c:IsCode(14763299,62895219)
	end
end

-- Motor モーター 
-- Fiendish Engine Ω
function Card.IsMotor(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x537) or c:IsFusionCode(82556058)
	else
		return c:IsSetCard(0x537) or c:IsCode(82556058)
	end
end

-- Neko (list to update) 猫
-- Dark Cat with White Tail/Kinka-byo/Black Cat-astrophe
-- Ghostrick Nekomusume/A Cat of Ill Omen/Lunalight Cat Dancer
-- Lunalight Blue Cat/Quantum Cat
c420.OCGNeko={
	84224627,43352213
}
function Card.IsNeko(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x538) or c:IsFusionCode(table.unpack(c420.OCGNeko))
	else
		return c:IsSetCard(0x538) or c:IsCode(table.unpack(c420.OCGNeko))
	end
end

-- Number 39: Utopia (archetype)  
-- Ｎｏ．３９ 希望皇ホープ
-- ナンバーズ３９ きぼうおうホープ 
-- Number S39: Utopia the Lightning/Number S39: Utopia Prime/Number 39: Utopia
-- Number 39: Utopia Roots
c420.OCGN39Utopia={
	
}
function Card.IsN39Utopia(c,fbool)
	if Card.IsCN39UtopiaRay(c,fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x539) or c:IsFusionCode(table.unpack(c420.OCGN39Utopia))
	else
		return c:IsSetCard(0x539) or c:IsCode(table.unpack(c420.OCGN39Utopia))
	end
end

-- Number C39: Utopia Ray (archetype) 
-- ＣＮｏ．３９ 希望皇ホープレイ 
-- カオスナンバーズ３９ きぼうおうホープレイ 
-- Number C39: Utopia Ray/Number C39: Utopia Ray Victory/Number C39: Utopia Ray V
c420.OCGCN39UtopiaRay={
	
}
function Card.IsCN39UtopiaRay(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x1539) or c:IsFusionCode(table.unpack(c420.OCGCN39UtopiaRay))
	else
		return c:IsSetCard(0x1539) or c:IsCode(table.unpack(c420.OCGCN39UtopiaRay))
	end
end
-- Number S 
-- ＳＮｏ.
-- シャイニングナンバーズ 
-- Number S39: Utopia the Lightning/Number S39: Utopia the Lightning/Number S0: Utopic ZEXAL
c420.OCGNumberS={
	52653092,56832966,86532744
}
function Card.IsNumberS(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x2048) or c:IsFusionCode(table.unpack(c420.OCGNumberS))
	else
		return c:IsSetCard(0x2048) or c:IsCode(table.unpack(c420.OCGNumberS))
	end
end

-- Numeron ヌメロン 
-- Number 100: Numeron Dragon
-- Rank-Up-Magic Numeron Force
-- Rank-Down-Magic Numeron Fall
c420.OCGNumeron={
	57314798,48333324,71345905
}
function Card.IsNumeron(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x53a) or c:IsFusionCode(table.unpack(c420.OCGNumeron))
	else
		return c:IsSetCard(0x53a) or c:IsCode(table.unpack(c420.OCGNumeron))
	end
end

-- Papillon (not finished) パピヨン
-- Moonlit Papillon
function Card.IsPapillon(c,fbool) 
	if fbool then
		return c:IsFusionSetCard(0x53c) or c:IsFusionCode(16366944)
	else
		return c:IsSetCard(0x53c) or c:IsCode(16366944)
	end
end

-- Parasite パラサイト
-- Graydle Parasite/Fusion Parasite
function Card.IsParasite(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x53d) or c:IsFusionCode(49966595,6205579)
	else
		return c:IsSetCard(0x53d) or c:IsCode(49966595,6205579)
	end
end

-- Pixie (not finished) 
-- 妖精
-- ようせい
-- Ghost Fairy Elfobia/Fairy of the Fountain/Prickle Fairy
-- Dreamsprite/Mystical Fairy Elfuria/Star Grail Fairy Ries
-- Super Quantal Fairy Alphan/Rose Fairy/Fairy King Albverdich
-- Fairy King Truesdale/Fairy Knight Ingunar/Fairy's Gift/
-- Fairy Wind/Ancient Pixie Dragon
c420.OCGPixie={
	44663232,81563416,91559748,8687195,85239662,21893603,90925163,58753372,44125452,42921475,52022648,
	55623480,86937530,45425051,28290705,19684740,68401546,73507661,4179255
}
function Card.IsPixie(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x53e) or c:IsFusionCode(table.unpack(c420.OCGPixie))
	else
		return c:IsSetCard(0x53e) or c:IsCode(table.unpack(c420.OCGPixie))
	end
end

-- Priestess 
-- 巫女
-- みこ
-- Priestess with Eyes of Blue/Maiden of the Aqua/Winda, Priestess of Gusto
-- Star Grail-Bearing Priestess/Ariel, Priestess of the Nekroz/Gravekeeper's Priestess
c420.OCGPriestess={
	
}
function Card.IsPriestess(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x53f) or c:IsFusionCode(table.unpack(c420.OCGPriestess))
	else
		return c:IsSetCard(0x53f) or c:IsCode(table.unpack(c420.OCGPriestess))
	end
end

-- Puppet パペット
-- Puppet Master/Junk Puppet/Puppet Ritual
-- Puppet King/Puppet Plant
c420.OCGPuppet={
	
}
function Card.IsPuppet(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x540) or c:IsFusionSetCard(0x83) or c:IsFusionCode(table.unpack(c420.OCGPuppet))
	else
		return c:IsSetCard(0x540) or c:IsSetCard(0x83) or c:IsCode(table.unpack(c420.OCGPuppet))
	end
end

-- Raccoon (not finished) 狸
-- Baby Raccoon Tantan/Baby Raccoon Ponpoko/Turtle Raccoon
-- Number 64: Ronin Raccoon Sandayu
c420.OCGRacoon={
	92729410,28118128,39972130,39972129,17441953
}
function Card.IsRaccoon(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x542) or c:IsFusionCode(table.unpack(c420.OCGRacoon))
	else
		return c:IsSetCard(0x542) or c:IsCode(table.unpack(c420.OCGRacoon))
	end
end

-- Red (archetype) レッド
-- U.A. Dreadnought Dunker/Eternal Dread/Ojama Red
-- Number C106: Giant Red Hand/Construction Train Signal Red/The Wicked Dreadroot
-- Red Carpet/Red Cocoon/Red Nova Dragon
-- Red Screen/Dark Red Enchanter/Super Quantum Red Layer
-- Destiny HERO - Dreadmaster/Destiny HERO - Dread Servant/Dread Dragon
-- Akakieisu/Red Gadget/Red Gardna/Opticlops
-- Red Sprinter/Red Supremacy/Red Duston
-- Tyhone #2/Crimson Ninja/Red Nova
-- Red Medicine/Red Mirror/Red Rising Dragon
-- Red Resonator/Red Wyvern/Lord of the Red
-- Hundred Eyes Dragon
c420.OCGRed={
	58831685,10202894,65570596,511001464,511001094,68722455,58165765,
	45462639,511001095,511000365,14886469,30494314,81354330,86445415,
	100000562,34475451,40975574,37132349,61019812,19025379,76547525,
	55888045,97489701,67030233,65338781,45313993,8706701,21142671,72318602
}
function Card.IsRed(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x543) or c:IsFusionSetCard(0x3b) or c:IsFusionSetCard(0x1045) or c:IsFusionCode(table.unpack(c420.OCGRed))
	else
		return c:IsSetCard(0x543) or c:IsSetCard(0x3b) or c:IsSetCard(0x1045) or c:IsCode(table.unpack(c420.OCGRed))
	end
end

-- Rose ローズ list to update
-- Aromaseraphy Rosemary/Aromage Rosemary/Crystal Rose
-- Crystron RosenixBlack Rose Moonlight Dragon/Koa'ki Meiru Gravirose
-- Kozmoll Wickedwitch/Regenerating Rose/Splendid Rose
-- Swallow's Nest/Twilight Rose Knight/Naturia Rosewhip
-- HERO's Bond/Hero's Rule 2/Windrose the Elemental Lord
-- Rose, Warrior of Revenge/Witch of the Black Rose/Black Rose Dragon
-- Blue Rose Dragon/Fallen Angel of Roses/Revival Rose
-- Queen Angel of Roses/Rose Archer/Rose Witch
-- Rose Tentacles/Bird of Roses/Rose Paladin

c420.OCGRose={
	49674183,96470883,31986288,41160533,51085303,41201555,75252099,
	58569561,96385345,17720747,98884569,23087070,1557341,12469386,
	2986553,51852507,44125452,61049315,79531196,89252157,32485271,
	33698022,73580471,4290468,25090294,45247637,71645243
}
function Card.IsRose(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x544) or c:IsFusionCode(table.unpack(c420.OCGRose))
	else
		return c:IsSetCard(0x544) or c:IsCode(table.unpack(c420.OCGRose))
	end
end

-- Seal 
-- 封じ
-- ふうじ
-- Mask of Restrict/Block Attack/Stop Defense
-- Anti-Spell Fragrance
c420.OCGSeal={
	63102017,29549364,25880422,58921041,
}
function Card.IsSeal(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x545) or c:IsFusionCode(table.unpack(c420.OCGSeal))
	else
		return c:IsSetCard(0x545) or c:IsCode(table.unpack(c420.OCGSeal))
	end
end

-- Shaman シャーマン 
-- Elemental HERO Necroid Shaman/Sylvan Sagequoia/The Legendary Fisherman
-- The Legendary Fisherman III/The Legendary Fisherman II/Lumina, Twilightsworn Shaman
-- Neo Flamvell Shaman
c420.OCGShaman={
	81003500,10530913,3643300,44968687,19801646,56166150,39761138
}
function Card.IsShaman(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x546) or c:IsFusionCode(table.unpack(c420.OCGShaman))
	else
		return c:IsSetCard(0x546) or c:IsCode(table.unpack(c420.OCGShaman))
	end
end

-- Shark (archetype)(not finished) シャーク 
c420.OCGShark={
	
}
function Card.IsShark(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x547) or or c:IsFusionCode(table.unpack(c420.OCGShark))
	else
		return c:IsSetCard(0x547) or c:IsCode(table.unpack(c420.OCGShark))
	end
end

-- Shining (not finished) シャイニング
-- Elemental HERO The Shining/Elemental HERO Shining Phoenix Enforcer/Elemental HERO Shining Flare Wingman
-- Leeching the Light/SZW - Fenrir Sword/Shining Hope Road
-- Radiant Mirror Force/Number 104: Masquerade/Blue-Eyes Shining Dragon
c420.OCGShining={
	22061412,88820235,25366484,62829077,53347303,90263923,12927849,21481146,2061963
}
function Card.IsShining(c,fbool)
	if c:IsNumberS(fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x548) or c:IsFusionCode(table.unpack(c420.OCGShining))
	else
		return c:IsSetCard(0x548) or c:IsCode(table.unpack(c420.OCGShining))
	end
end

-- Skiel
-- スキエル
function Card.IsSkiel(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x549) or c:IsFusionCode(31930787,75733063)
	else
		return c:IsSetCard(0x549) or c:IsCode(31930787,75733063)
	end
end

-- Sky (not finished) 
-- 天
-- てん
-- Fire Formation - Tenki/Fire Formation - Tenken/Fire Formation - Tensu
-- Fire Formation - Tensen/Slifer the Sky Dragon/Injection Fairy Lily
-- Number C9: Chaos Dyson Sphere/Crow Goblin/Absorbing Kid from the Sky
-- Earthshattering Event/Great Long Nose/Phantasm Spiral Assault
-- Cyber Angel Idaten/Cyber Angel Benten/Balance of Judgment
-- Grand Horn of Heaven/Horn of Heaven/Black Horn of Heaven
-- A Wild Monster Appears!/Gaia Drake, the Universal Force/Needle Ceiling
-- Unification/Tenkabito Shien/Ascension Sky Dragon
-- The Fountain in the Sky/Sky Iris/Zeradias, Herald of Heaven
-- The Sanctuary in the Sky/Cards from the Sky/Goblin Fan
-- Dark Highlander/Sky Galloping Gaia the Dragon Champion/Lullaby of Obedience
-- Beginning of Heaven and Earth/Ehther the Heavenly Monarch/Edea the Heavenly Squire
-- Divine Wrath/Convulsion of Nature/Sky Scourge Invicil
-- Sky Scourge Enrise/Sky Scourge Norleras/Tenmataitei
-- Noble Arms of Destiny/Card of Sanctity/Celestial Wolf Lord, Blue Sirius
-- Number 9: Dyson Sphere/Number 44: Sky Pegasus/Blustering Winds
-- Blackwing - Jetstream the Blue Sky/Blackwing - Hillen the Tengu-wind/
-- Ancient Brain/World of Prophecy/Reborn Tengu

-- Nordic Ascendant/Skyscraper
c420.OCGSky={
	
}
function Card.IsSky(c,fbool)
	if Card.IsAngel(c,fbool) or Card.IsCelestial(c,fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x54a) or c:IsFusionCode(table.unpack(c420.OCGSky)) or c:IsFusionSetCard(0xf6) or c:IsFusionSetCard(0x3042)
	else
		return c:IsSetCard(0x54a) or c:IsCode(table.unpack(c420.OCGSky)) or c:IsSetCard(0xf6) or c:IsSetCard(0x3042)
	end
end

-- Slime スライム 
-- Slime Toad/Graydle Slime/Graydle Slime Jr.
-- Jam Breeding Machine/Slime token/Change Slime
-- Jam Defender/D/D Swirl Slime/D/D Necro Slime
-- Magical Reflect Slime/Metal Reflect Slime/Revival Jam
c420.OCGSlime={
	31709826,46821314,3918345,26905245,5600127,45206713,
	72291412,21770261
}
function Card.IsSlime(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x54b) or c:IsFusionCode(table.unpack(c420.OCGSlime))
	else
		return c:IsSetCard(0x54b) or c:IsCode(table.unpack(c420.OCGSlime))
	end
end

-- Sphere スフィア 
-- Abyss-sphere/Vylon Sphere/Number C9: Chaos Dyson Sphere
-- The Atmosphere/Sphere of Chaos/Blast Sphere
-- Daigusto Sphreez/Darkness Neosphere/Troposphere
-- Transforming Sphere/Number 9: Dyson Sphere/Heliosphere Dragon
-- Thought Ruler Archfiend/The Winged Dragon of Ra - Sphere Mode
c420.OCGSphere={
	60202749,75886890,32559361,14466224,82693042,26302522,
	29552709,60417395,72144675,66094973,1992816,51043053,
	70780151,10000080
}
function Card.IsSphere(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x54c) or c:IsFusionCode(table.unpack(c420.OCGSphere))
	else
		return c:IsSetCard(0x54c) or c:IsCode(table.unpack(c420.OCGSphere))
	end
end

-- Spirit (archetype) 
-- 精霊 
-- スピリット

-- Blue-Eyes Spirit Dragon

function Card.IsSpirit(c,fbool)
	if fbool then
		return (c:IsFusionSetCard(0x54e) or c:IsFusionCode(59822133))
	else
		return (c:IsSetCard(0x54e) or c:IsCode(59822133))
	end
end

-- Starship スターシップ
-- Starship Spy Plane
-- Number 42: Galaxy Tomahawk
function Card.IsStarship(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x54f) or c:IsFusionCode(15458892,10389142)
	else
		return c:IsSetCard(0x54f) or c:IsCode(15458892,10389142)
	end
end

-- Statue (not finished) スタチュー
c420.OCGStatue={
	75209824,3129635,49514333,9197735
}
function Card.IsStatue(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x550) or c:IsFusionCode(table.unpack(c420.OCGStatue))
	else
		return c:IsSetCard(0x550) or c:IsCode(table.unpack(c420.OCGStatue))
	end
end

-- Stone (list to do)
-- 岩石 
-- がんせき
-- Boulder Tortoise/Giant Soldier of Stone/Rock Spirit/Sentry Soldier of Stone
c420.OCGStone={
	9540040,13039848,82818645,57354389
}
function Card.IsStone(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x551) or c:IsFusionCode(table.unpack(c420.OCGStone))
	else
		return c:IsSetCard(0x551) or c:IsCode(table.unpack(c420.OCGStone))
	end
end

-- Superheavy
-- 超重
-- ちょうじゅう 

-- Tachyon タキオン
c420.OCGTachyon={
	-- Tachyon Transmigrassion, Tachyon Chaos Hole
	8038143,59650656
}
function Card.IsTachyon(c,fbool)
	if Card.IsTachyonDragon(c,fbool) then return true end
	if fbool then
		return c:IsFusionSetCard(0x555) or c:IsFusionCode(table.unpack(c420.OCGTachyon))
	else
		return c:IsSetCard(0x555) or c:IsCode(table.unpack(c420.OCGTachyon))
	end
end

-- Tachyon Dragon 
-- 時空竜
-- タキオン・ドラゴン
c420.OCGTachyonDragon={
	-- N107, CN107
	88177324,68396121
}
function Card.IsTachyonDragon(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x1555) or c:IsFusionCode(table.unpack(c420.OCGTachyonDragon))
	else
		return c:IsSetCard(0x1555) or c:IsCode(table.unpack(c420.OCGTachyonDragon))
	end
end

-- Toy トイ
-- Stoic Challenge/Toy Knight/Toy Vendor
-- Toy Magician/Light Laser
c420.OCGToy={
	37364101,1826676,70245411,58132856,11471117
}
function Card.IsToy(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x559) or c:IsFusionCode(table.unpack(c420.OCGToy))
	else
		return c:IsSetCard(0x559) or c:IsCode(table.unpack(c420.OCGToy))
	end
end

-- Toy (ARC-V archetype) トーイ
function Card.IsToyArcV(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x55a) or c:IsFusionSetCard(0xad) 
	else
		return c:IsSetCard(0x55a) or c:IsSetCard(0xad) 
	end
end

-- V (Zexal archetype)
-- V
-- ブイ

-- White ホワイト
-- Great White/Malefic Blue-Eyes White Dragon/The All-Seeing White Tiger
-- Deep-Eyes White Dragon/ Paladin of White Dragon/ Naturia White Oak
-- White Night Dragon/Blue-Eyes Alternative White Dragon/Blue-Eyes White Dragon
-- The White Stone of Ancients/The White Stone of Legend/White Magical Hat
-- White Duston/White Dolphin/White Night Queen
-- White ninja/White Hole/White-Horned Dragon
-- White Potan/Lunalight White Rabbit
-- to add: White Aura Dolphin; White Aura Whale; White Moray
c420.OCGWhite={
	13429800,9433350,32269855,22804410,73398797,24644634,
	79473793,38517737,89631139,71039903,79814787,15150365,
	3557275,92409659,20193924,1571945,43487744,73891874,
	98024118,84812868
}
function Card.IsWhite(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x55d) or c:IsFusionCode(table.unpack(c420.OCGWhite))
	else
		return c:IsSetCard(0x55d) or c:IsCode(table.unpack(c420.OCGWhite))
	end
end

-- Wisel
-- ワイゼル
-- Meklord Emperor Wisel/Meklord Army of Wisel
function Card.IsWisel(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x560) or c:IsFusionCode(68140974,39648965)
	else
		return c:IsSetCard(0x560) or c:IsCode(68140974,39648965)
	end
end

-- Yomi 黄泉
-- Treeborn Frog
-- Yomi Ship
c420.OCGYomi={
	12538374,51534754
}
function Card.IsYomi(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x563) or c:IsFusionCode(12538374,51534754)
	else
		return c:IsSetCard(0x563) or c:IsCode(12538374,51534754)
	end
end

-- Yubel (archetype) ユベル
c420.OCGYubel={
	-- Yubel, Yubel terror, Yubel nighmare
	78371393,4779091,78371393
}
function Card.IsYubel(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x561)  or c:IsFusionCode(table.unpack(c420.OCGYubel))
	else
		return c:IsSetCard(0x561) or c:IsCode(table.unpack(c420.OCGYubel))
	end
end

-- ∞ (Infinity)
-- ∞
-- インフィニティ
-- Meklord Astro Mekanikle/Meklord Emperor Granel/Meklord Emperor Skiel/Meklord Emperor Wisel
c420.OCGInfinity={
	63468625,4545683,31930787,68140974
}
function Card.IsInfinity(c,fbool)
	if fbool then
		return c:IsFusionSetCard(0x562) or c:IsFusionCode(table.unpack(c420.OCGInfinity))
	else
		return c:IsSetCard(0x562) or c:IsCode(table.unpack(c420.OCGInfinity))
	end
end
