//
//  Vocabulary.swift
//  bobo
//
//  Created by Jim Hsu on 2019/7/20.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
//

import Foundation

//struct MpsE12:Codable{
//    let mps:Mps
//    let e12:VocabularyE12
//}

struct VocabularyE12:Codable{
    
    static let tradE12:VocabularyE12 = {
//        let s01:Set<Character> = Set(ta01.map({$0}))
        return VocabularyE12(ArrayE12 : [ta00, ta01,ta02,ta03,ta04,ta05,ta06,ta07, ta08, ta09, ta10, ta11])
        //return VocabularyE12(set01: s01, set02: s02, set03: s03, set04: s04, set05: s05, set06: s06, set07: s07, set08: s08, set09: s09, set10: s10, set11: s11, set12: s12)
    }()
    
//    func mpsHit(mps:Mps) -> VocabularyE12{
//        for ex in self.ArrayE12{
//            ex.compactMap({MpsPhone(})
//        }
//    }
    let mpsOrNil:Mps? = nil
    let ArrayE12:[[Character]]
//    let set02:Set<Character>
//    let set03:Set<Character>
//    let set04:Set<Character>
//    let set05:Set<Character>
//    let set06:Set<Character>
//    let set07:Set<Character>
//    let set08:Set<Character>
//    let set09:Set<Character>
//    let set10:Set<Character>
//    let set11:Set<Character>
//    let set12:Set<Character>
    //static let tSet01:Set<Character> = Set(ta01.map({$0}))
    //e1 s1, 100
    static let ta00:[Character] = Array("一二三十木禾上下土個八入大天人火文六七兒九無口日中了子門月不開四五目耳頭米見白田電也長山出飛馬鳥雲公車牛羊小少巾尺毛卜又心風力手水廣升足走方半巴業本平書自已東西回片皮生里果幾用魚今正雨兩瓜衣來年左右") //100 Elemental grade 1, 1st semester
    //e2 s1, 350
    static let ta01:[Character] = Array("萬丁冬百齊說話朋友春高你們紅綠花草爺節歲親的行古聲多處知忙洗認掃真父母爸全關寫完家看著畫笑興會媽奶午合放收女太氣早去亮和語千李秀香聽唱連遠定向以後更主意總先干趕起明凈同工專才級隊詩林童黃閉立是朵美我葉機她他送過時讓嗎吧蟲往得很河姐借呢呀哪園因為臉陽光可石辦法找許別到那都嚇叫再象像做點照井鄉面忘想念王從邊這進道貝原男愛蝦跑吹地快樂老師拉把給活種吃練習苦學非常問間伙伴共汽分要沒位孩選北南江湖秋只星雪幫請就球玩跳桃樹剛蘭各坐座帶急名發成晚動新有在什麼變條螞蟻前空房網短對冷淡熱情沙海橋竹軍苗誰怕跟涼量最")
    
    //e2, s2, 300 words
    static let ta02 :[Character] = Array("波浪燈作字苹麗勞尤其區巨它安塊站已甲豆識紛經如好娃窪於首枝楓記劉休伸甜歌院除息您牽困員青寧室樣校切教響班欠元包鍾嘆哈遲鬧及身仔細次外計怦禮加億潔歡祖旗幟慶曲央交市旁優陰壇城國圖申匹互京淚洋擁抱相揚講打指接驚故侯奇信沿拾際蛙錯答還言每治棵掛哇怪慢怎思穿彎比服淺漂啦啊夫表示號汗傷吸極串免告訴狐狸猴顆采背板椅但傍清消由術吐注課鉛筆桌景拿壞松扎抓祝福句幸之令布直當第現期輪路戶亞角周床病始張尋哭良食雙體操場份粉昨晴姑娘妹讀舟乘音客何汪羽領捉理躍蹦靈晨失覺扔掉眼睛紙船久乎至死腰撿粒被並夜喜重味輕刻群沖曬池浮災害黑器岸紋洞影倒游圓圍杯件住須能飄必事歷史滅克化代孫植廠產介農科技紡織衛運宇宙航艦叢牢拍護保物雞貓丑永飢飽溫貧富斤折挑根獨滿容易寸落補拔功助取所夕與川州台爭民族胡戲棋鋼觀彈琴養宜實色華谷金盡層豐壯")
    
    //e2, s2, 300
    static let ta03 : [Character] = Array("脫凍溪棉探搖野躲解未追店枯徐燒榮菜宿岡世界轟筍芽喊呼喚弟哥骨抽拐澆終靜躺謝漸微瓦泉然結股脆塔杜鵑冒雷需邁迷跡叔鋒滴灑泥濘撲托摸利鈴弱末芬芳夏應該島展建紗環繞勝隱約省茂盛吾季留杏密蜜坡搭摘釘溝夠龍恩壽柏潑特敬鮮腳度鳳凰束勾府單奪宮扮雄偉爍輝煌色另志題提漫朗哄喝騙刀爾求仍使便英票整式而且丹烏藝顯忽絲杆眨濤陳轉斜吳含窗爐嶺鳴絕銀煙泊流柳垂亂沉壓逃越陣彩虹蟬蜘蛛冊岩寶趴印刨埋陸鐵質厚底忠導盞積稠稀針碰慌兄呆商抹擠拱決價錢購批評報玻璃拾破碎滑繼續封驕傲拎桶停聰胳膊甸晃盪叭玲狗糟樓梯肯腦筋訝談派引列峰敲附近守丟焦費望算此樁肥灰討厭冰蛋殼鴨欺負鵝翅膀勺斗玉組珍珠數鑽研睡距離油檢查團斥責炎夸獎亡肉耐謎傳染類嚴寒")
    
    //e3, s1, 300
    static let ta04: [Character] = Array("坪壩戴招蝴蝶孔雀舞銅粗尾要裝勁絨朝些釣察瓣攏掌趣爬峰頂似蒼仰咱奮辮勇居郊散步胸脯渣或者敢惜低誠基突按擺弄准備側膠卷輛秘雜社著藏悄閃坑臣推旅考秦紀遺究震促深憶異逢佳倍遙遍插精希卻依拼命奔村抖喪磨坊扇枚郵爽柿仙梨菠蘿糧緊楊艷內夢醒蘇濕嬌嫩強適昆播修致論試驗袋證概減阻測括確誤途超堂鏡閒待閱腿隨調簡拜訪具聞塵仆納悶丘迎等止境授品暗降丈肢肌膚遼闊血液滋潤創造縣設參部橫跨舉擊堅固欄案爪貴斷楚孤帆藍懶披劃威武揀顔形狀漁料輩匯欣賞映擋視線浸獻藥材軟刮舌矛盾集持般架龜攻炮坦戰神兵退挖鞋斧鋸免屋搶難初管敵階懂陶謙虛嘴惱怒吵感荒捧朴素值受願姿勢投況吞烈緒述普通鼓勵育瓶系繩茶危險順倆索激堵獲予擔寬裕買猜糖即卡盼仁貼")
    //e3, s2, 300
    static let ta05: [Character] = Array("燕聚增掠稻尖偶沾圈漾倦符演贊詠碧妝裁剪濱紫荷挨蓮蓬帳仿佛裳翩蹈蜻蜓翠稈腹赤襯衫透泛泡飼翁陡壁歐洲瑞士舒啟殊驟涉疲政踏救載森郁蔥湛蓋犁砍裸擴棟柴喘黎寓則窟窿狼叼街勸悔盤纏硬弓魏射箭獵雁弦悲慘愈痛裂叮囑排靠幅審肅晌悅熟悉誨賽疼憂慰梭雖狂贏暑益窮將若俱博鴉截伍默局棒羨慕禁席眾糾匠替抄墨罵縮承肩扛緣憤畢戒既賀顧迅速復恰犯緩婆議達稚煩享炸醫輸眉型否墊酒掩咬拳制柔渴罐累竟匆哀舔反遞忍湊咽唾沫涌差抵氏莊稼獸存繁殖蔬麻較殺預幕臨懸曾奧努登任撒藻旦項估齡絡箱迫悟盯鼠唐警眯覽敞寄秒戀彤霞陪趁窄脖段漆膽蹤鎮攤鼻憂換摔豎賣售馱構端掏館飯辨堆模付標齒乞巧霄渡屏燭曉偷淹官逼姓睜旱徒騰催吊跪渠灌溉隆塌露燃熊掙熄噴缺純冶煉盆")
    //e4, s1, 200
    static let ta06:[Character] = Array("潮稱鹽籠罩蒙薄霧昂沸貫舊恢燦爛竿茫槳規律支株縫隙耀梢寂莫臘渾疑虎占鋪均勻疊莖柄觸痕逐宅蔽棄毫遇擇址穴掘搜傾扒拋溢允牆牌添訓覆凝辣酷愉拆融剩伐煤頸鄭厲劇餐倘飲侍脾蹲供鄰性格憑貪職癢稿踩梅蛇跌撞辟崇旋嘉磚隔屯堡壘仗扶智慧魄殿廊柱栽築閣朱堤雕獅態孟浩陵辭唯舍君洪暴猛漲褲懶穩俗衡序伏峽桂移灣彼襲余懷曠暫胞脈帝義伯租振范闖凡巡嚷婦懲篇薦翻簾頁刪詞燥握洽昏廳糊改程賴耕駕幻潛核控聯哲歸恐凶笨鴿僅頓描繪噸盈敏捷嶄")
    //e4, s2, 200
    static let ta07:[Character] = Array("亭庭潭螺諳瀾瑕攀巒泰駱駝羅障兀綿浙桐簇濃臀稍額擦蜿蜒乳據源維財屬貨馳贈駛德惑碼庫捎橡撥尊沃呈憊堪善款例瘦傑喉捶僵配幼灘偵嘲啄企愚蠢返吁攔鷗帽徹蝙蝠捕蛾蚊避銳鐺蠅揭礙熒削餵哨挺斯甩踢槍防鬼漢滾毀慣犧牲凱征阿姨濟貢聖駐罪惡健康徑暢磕絆瞬弧翔權繽擾欲屈茁診撼蹋限棚飾冠菊瞧率覓聳搗搬巢諧眠辛蠶桑晝耕績塞鷺笠略辯奉違磅拴拖釋宣薩妄執港澈壺缸罷苟繡揮徽聾啞昌妻刺綁扁鵲蔡睬腸胃燙劑湯焰驅袖敗罰佩饒抗押鎖狠膝肝髒")
    //2000 so far,
    
    //e5, s1, 150
    static let ta08:[Character] = Array("竊炒鍋踮喲餓懼充檐皺碗酸撐櫃侶娛盒豫趟誦零編某洛榆畔帳魂縷幽葬愁腮甚綢謂梳衰絹僑鯨豬齶哺濾肚肺矮判胎盜嫌夾恙藕粘噪廢撈餌濺鉤翼縱啪鰓皎唇沮誘誡踐畝嘗吩咐茅榨榴杉磯混昔墟曼疾爆礫砸顫糕迪摟豪謄置司妙版慈祥歧謹慎損皇瓏剔杭萊瑤宏宋侵統銷瑰燼廟務葛吼腔崎嶇屍斬墜雹仇恨眺丸崖岷典副委協賓澤奏誕鈕瞻拂騎嗓黨")
    //e5, s2, 150
    static let ta09:[Character] = Array("毯渲勒吟迂襟蹄貌拘羞澀跤偏涯晰傘撫紹疆陷牧蓑遮醉媚鋤剝氈卸咀嚼漠寞襖袍傻胚禍患臂賦淘妨豈絞汁厘愧虧梁惠詣乃曰禽侮辱謊敝矩囚嘻臣淮柑橘枳賊賠妮役硝炭誼謠噩耗跺嫂挎籃咆哮瘋獰淌肆揪豹瞪呻膛攙祭奠趙璧召諾怯瑟拒諸荊妒忌曹督甘魯延幔私寨擂吶援丞擻綻扳咚監侄郎皆斂媳騷宗憐帕脊莞錦奼嫣暇頗尼艇叉艄翹翹艙姆禱雇嘩")
    //e6, s1, 80
    static let ta10:[Character] = Array("邀俯瀑峭軀津蘊俠謐巷俏逗龐烘烤韻勤勉吻施撓庸艱毅鏟劣惹譏漿岔摯寢頻朦朧淒斑篇擱填怨掀唉裹魁梧淋撕霉慮悠儀歉溜嘿割晶瑩藹資礦賜竭濫脅睹嗡鹿駿鷹潺脂嬰眷扭胯廚套蝟畜竄挽囫圇棗搞恍霜詳逝章咳嗽塑寇蕉筒躁革遭泣浴搏碑茵蠟陌盲鍵粼霎錄")
    //e6, s2, 80
    static let ta11:[Character] = Array("挪蒸秧萎番鍛雅勃旬熬蒜醋餃翡拌榛栗箏鞭麥寺逛籍屜怖瞅魔胖刑哼峻殘匪窩啃舅鴻鼎旺炊乖裙兜幣哎櫥銹摩揉瑪蘸毒撇噎搓匣喳吭娜伊攪埃倫藤析鹼頑卓效蝕乏譽銜糞捐澡械逆玫域")
}