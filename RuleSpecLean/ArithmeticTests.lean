import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel

#guard match arithmetic .add ⟨(1), 0⟩ ⟨(3), 0⟩ with
  | .ok v => v == ⟨(4), 0⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(1), 0⟩ ⟨(3), 0⟩ with
  | .ok v => v == ⟨(-2), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(1), 0⟩ ⟨(3), 0⟩ with
  | .ok v => v == ⟨(3), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(1), 0⟩ ⟨(3), 0⟩ with
  | .ok v => v == ⟨(3333333333333333333333333333), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(1), 0⟩ ⟨(0), 0⟩ with
  | .ok v => v == ⟨(1), 0⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(1), 0⟩ ⟨(0), 0⟩ with
  | .ok v => v == ⟨(1), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(1), 0⟩ ⟨(0), 0⟩ with
  | .ok v => v == ⟨(0), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(1), 0⟩ ⟨(0), 0⟩ with
  | .error e => e == .divisionByZero
  | .ok _ => false
#guard match arithmetic .add ⟨(0), 0⟩ ⟨(0), 0⟩ with
  | .ok v => v == ⟨(0), 0⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(0), 0⟩ ⟨(0), 0⟩ with
  | .ok v => v == ⟨(0), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(0), 0⟩ ⟨(0), 0⟩ with
  | .ok v => v == ⟨(0), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(0), 0⟩ ⟨(0), 0⟩ with
  | .error e => e == .divisionByZero
  | .ok _ => false
#guard match arithmetic .add ⟨(-1), 0⟩ ⟨(6), 0⟩ with
  | .ok v => v == ⟨(5), 0⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-1), 0⟩ ⟨(6), 0⟩ with
  | .ok v => v == ⟨(-7), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-1), 0⟩ ⟨(6), 0⟩ with
  | .ok v => v == ⟨(-6), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-1), 0⟩ ⟨(6), 0⟩ with
  | .ok v => v == ⟨(-1666666666666666666666666667), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(79228162514264337593543950335), 0⟩ ⟨(1), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .sub ⟨(79228162514264337593543950335), 0⟩ ⟨(1), 0⟩ with
  | .ok v => v == ⟨(79228162514264337593543950334), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(79228162514264337593543950335), 0⟩ ⟨(1), 0⟩ with
  | .ok v => v == ⟨(79228162514264337593543950335), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(79228162514264337593543950335), 0⟩ ⟨(1), 0⟩ with
  | .ok v => v == ⟨(79228162514264337593543950335), 0⟩
  | .error _ => false
#guard match arithmetic .add ⟨(79228162514264337593543950335), 0⟩ ⟨(1), 1⟩ with
  | .ok v => v == ⟨(79228162514264337593543950335), 0⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(79228162514264337593543950335), 0⟩ ⟨(1), 1⟩ with
  | .ok v => v == ⟨(79228162514264337593543950335), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(79228162514264337593543950335), 0⟩ ⟨(1), 1⟩ with
  | .ok v => v == ⟨(79228162514264337593543950335), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(79228162514264337593543950335), 0⟩ ⟨(1), 1⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .add ⟨(79228162514264337593543950335), 0⟩ ⟨(2), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .sub ⟨(79228162514264337593543950335), 0⟩ ⟨(2), 0⟩ with
  | .ok v => v == ⟨(79228162514264337593543950333), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(79228162514264337593543950335), 0⟩ ⟨(2), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(79228162514264337593543950335), 0⟩ ⟨(2), 0⟩ with
  | .ok v => v == ⟨(39614081257132168796771975168), 0⟩
  | .error _ => false
#guard match arithmetic .add ⟨(1), 28⟩ ⟨(1), 1⟩ with
  | .ok v => v == ⟨(1000000000000000000000000001), 28⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(1), 28⟩ ⟨(1), 1⟩ with
  | .ok v => v == ⟨(-999999999999999999999999999), 28⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(1), 28⟩ ⟨(1), 1⟩ with
  | .ok v => v == ⟨(0), 28⟩
  | .error _ => false
#guard match arithmetic .div ⟨(1), 28⟩ ⟨(1), 1⟩ with
  | .ok v => v == ⟨(1), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(100), 2⟩ ⟨(20), 1⟩ with
  | .ok v => v == ⟨(300), 2⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(100), 2⟩ ⟨(20), 1⟩ with
  | .ok v => v == ⟨(-100), 2⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(100), 2⟩ ⟨(20), 1⟩ with
  | .ok v => v == ⟨(2000), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(100), 2⟩ ⟨(20), 1⟩ with
  | .ok v => v == ⟨(5), 1⟩
  | .error _ => false
#guard match arithmetic .add ⟨(0), 3⟩ ⟨(20), 1⟩ with
  | .ok v => v == ⟨(20), 1⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(0), 3⟩ ⟨(20), 1⟩ with
  | .ok v => v == ⟨(-20), 1⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(0), 3⟩ ⟨(20), 1⟩ with
  | .ok v => v == ⟨(0), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(0), 3⟩ ⟨(20), 1⟩ with
  | .ok v => v == ⟨(0), 0⟩
  | .error _ => false
#guard match arithmetic .add ⟨(1), 0⟩ ⟨(2), 0⟩ with
  | .ok v => v == ⟨(3), 0⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(1), 0⟩ ⟨(2), 0⟩ with
  | .ok v => v == ⟨(-1), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(1), 0⟩ ⟨(2), 0⟩ with
  | .ok v => v == ⟨(2), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(1), 0⟩ ⟨(2), 0⟩ with
  | .ok v => v == ⟨(50), 2⟩
  | .error _ => false
#guard match arithmetic .add ⟨(1), 28⟩ ⟨(1), 20⟩ with
  | .ok v => v == ⟨(100000001), 28⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(1), 28⟩ ⟨(1), 20⟩ with
  | .ok v => v == ⟨(-99999999), 28⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(1), 28⟩ ⟨(1), 20⟩ with
  | .ok v => v == ⟨(0), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(1), 28⟩ ⟨(1), 20⟩ with
  | .ok v => v == ⟨(1), 8⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-1), 28⟩ ⟨(79228162514264337593543950335), 0⟩ with
  | .ok v => v == ⟨(79228162514264337593543950335), 0⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-1), 28⟩ ⟨(79228162514264337593543950335), 0⟩ with
  | .ok v => v == ⟨(-79228162514264337593543950335), 0⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-1), 28⟩ ⟨(79228162514264337593543950335), 0⟩ with
  | .ok v => v == ⟨(-79228162514264337593543950335), 28⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-1), 28⟩ ⟨(79228162514264337593543950335), 0⟩ with
  | .ok v => v == ⟨(0), 0⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-15282481337120737340), 13⟩ ⟨(-23133592793941026661), 6⟩ with
  | .ok v => v == ⟨(-231335943221891603730737340), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-15282481337120737340), 13⟩ ⟨(-23133592793941026661), 6⟩ with
  | .ok v => v == ⟨(231335912656928929489262660), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-15282481337120737340), 13⟩ ⟨(-23133592793941026661), 6⟩ with
  | .ok v => v == ⟨(35353870013395451508393553343), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-15282481337120737340), 13⟩ ⟨(-23133592793941026661), 6⟩ with
  | .ok v => v == ⟨(660618584983626396919), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-64499889054313187100), 12⟩ ⟨(-91431400292276090563), 14⟩ with
  | .ok v => v == ⟨(-6541420305723594800563), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-64499889054313187100), 12⟩ ⟨(-91431400292276090563), 14⟩ with
  | .ok v => v == ⟨(-6358557505139042619437), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-64499889054313187100), 12⟩ ⟨(-91431400292276090563), 14⟩ with
  | .ok v => v == ⟨(58973151749323061495568334986), 15⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-64499889054313187100), 12⟩ ⟨(-91431400292276090563), 14⟩ with
  | .ok v => v == ⟨(70544570954976379021160612762), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-30909177384407395188), 0⟩ ⟨(-54065225277868542471), 11⟩ with
  | .ok v => v == ⟨(-30909177384948047440778685425), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-30909177384407395188), 0⟩ ⟨(-54065225277868542471), 11⟩ with
  | .ok v => v == ⟨(-30909177383866742935221314575), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-30909177384407395188), 0⟩ ⟨(-54065225277868542471), 11⟩ with
  | .ok v => v == ⟨(16711116384415853812860162830), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-30909177384407395188), 0⟩ ⟨(-54065225277868542471), 11⟩ with
  | .ok v => v == ⟨(57170162938468297695204850478), 18⟩
  | .error _ => false
#guard match arithmetic .add ⟨(30134605503524230362), 13⟩ ⟨(98026809714618128724), 10⟩ with
  | .ok v => v == ⟨(98056944320121652954362), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(30134605503524230362), 13⟩ ⟨(98026809714618128724), 10⟩ with
  | .ok v => v == ⟨(-97996675109114604493638), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(30134605503524230362), 13⟩ ⟨(98026809714618128724), 10⟩ with
  | .ok v => v == ⟨(29539992395190539513322121465), 12⟩
  | .error _ => false
#guard match arithmetic .div ⟨(30134605503524230362), 13⟩ ⟨(98026809714618128724), 10⟩ with
  | .ok v => v == ⟨(3074118763147959918024747), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-12416295116802917137), 7⟩ ⟨(48209544766781281780), 0⟩ with
  | .ok v => v == ⟨(482095435251517700997082863), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-12416295116802917137), 7⟩ ⟨(48209544766781281780), 0⟩ with
  | .ok v => v == ⟨(-482095460084107934602917137), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-12416295116802917137), 7⟩ ⟨(48209544766781281780), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-12416295116802917137), 7⟩ ⟨(48209544766781281780), 0⟩ with
  | .ok v => v == ⟨(-257548482916983435592), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-30164878633210406463), 12⟩ ⟨(13797533557911118449), 4⟩ with
  | .ok v => v == ⟨(1379753325626233211689593537), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-30164878633210406463), 12⟩ ⟨(13797533557911118449), 4⟩ with
  | .ok v => v == ⟨(-1379753385955990478110406463), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-30164878633210406463), 12⟩ ⟨(13797533557911118449), 4⟩ with
  | .ok v => v == ⟨(-41620092521203665524941608432), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-30164878633210406463), 12⟩ ⟨(13797533557911118449), 4⟩ with
  | .ok v => v == ⟨(-218625151420013845698), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-46284488826055399607), 4⟩ ⟨(55118774118094053435), 2⟩ with
  | .ok v => v == ⟨(5465592922983349943893), 4⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-46284488826055399607), 4⟩ ⟨(55118774118094053435), 2⟩ with
  | .ok v => v == ⟨(-5558161900635460743107), 4⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-46284488826055399607), 4⟩ ⟨(55118774118094053435), 2⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-46284488826055399607), 4⟩ ⟨(55118774118094053435), 2⟩ with
  | .ok v => v == ⟨(-83972275448088043048180863), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(56967830657708563339), 1⟩ ⟨(-76637962244527102476), 13⟩ with
  | .ok v => v == ⟨(56967830657631925376755472898), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(56967830657708563339), 1⟩ ⟨(-76637962244527102476), 13⟩ with
  | .ok v => v == ⟨(56967830657785201301244527102), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(56967830657708563339), 1⟩ ⟨(-76637962244527102476), 13⟩ with
  | .ok v => v == ⟨(-43658984550980824493217914649), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(56967830657708563339), 1⟩ ⟨(-76637962244527102476), 13⟩ with
  | .ok v => v == ⟨(-74333697020730441463095162212), 17⟩
  | .error _ => false
#guard match arithmetic .add ⟨(90253482518351166243), 1⟩ ⟨(69125060179048388823), 1⟩ with
  | .ok v => v == ⟨(159378542697399555066), 1⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(90253482518351166243), 1⟩ ⟨(69125060179048388823), 1⟩ with
  | .ok v => v == ⟨(21128422339302777420), 1⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(90253482518351166243), 1⟩ ⟨(69125060179048388823), 1⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(90253482518351166243), 1⟩ ⟨(69125060179048388823), 1⟩ with
  | .ok v => v == ⟨(13056550299497134146698462525), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(81502884304586584013), 11⟩ ⟨(-11043614379938680831), 3⟩ with
  | .ok v => v == ⟨(-1104361356490983778513415987), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(81502884304586584013), 11⟩ ⟨(-11043614379938680831), 3⟩ with
  | .ok v => v == ⟨(1104361519496752387686584013), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(81502884304586584013), 11⟩ ⟨(-11043614379938680831), 3⟩ with
  | .ok v => v == ⟨(-9000864251126110100243845147), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(81502884304586584013), 11⟩ ⟨(-11043614379938680831), 3⟩ with
  | .ok v => v == ⟨(-738009147192253964677), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(35252045358309245610), 9⟩ ⟨(-95489428411258901354), 1⟩ with
  | .ok v => v == ⟨(-9548942805873844777090754390), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(35252045358309245610), 9⟩ ⟨(-95489428411258901354), 1⟩ with
  | .ok v => v == ⟨(9548942876377935493709245610), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(35252045358309245610), 9⟩ ⟨(-95489428411258901354), 1⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(35252045358309245610), 9⟩ ⟨(-95489428411258901354), 1⟩ with
  | .ok v => v == ⟨(-36917223136454309192), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-75785847888694198884), 12⟩ ⟨(61964989500343545114), 8⟩ with
  | .ok v => v == ⟨(619574109155546756941116), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-75785847888694198884), 12⟩ ⟨(61964989500343545114), 8⟩ with
  | .ok v => v == ⟨(-619725680851324145338884), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-75785847888694198884), 12⟩ ⟨(61964989500343545114), 8⟩ with
  | .ok v => v == ⟨(-46960692686975690603104798259), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-75785847888694198884), 12⟩ ⟨(61964989500343545114), 8⟩ with
  | .ok v => v == ⟨(-1223043019934248975065021), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(13862502590972158697), 3⟩ ⟨(-10243568802115758067), 1⟩ with
  | .ok v => v == ⟨(-1010494377620603648003), 3⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(13862502590972158697), 3⟩ ⟨(-10243568802115758067), 1⟩ with
  | .ok v => v == ⟨(1038219382802547965397), 3⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(13862502590972158697), 3⟩ ⟨(-10243568802115758067), 1⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(13862502590972158697), 3⟩ ⟨(-10243568802115758067), 1⟩ with
  | .ok v => v == ⟨(-135328837622576693173798985), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-94001233419362722976), 14⟩ ⟨(79141169083820838438), 4⟩ with
  | .ok v => v == ⟨(79141169074420715096063727702), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-94001233419362722976), 14⟩ ⟨(79141169083820838438), 4⟩ with
  | .ok v => v == ⟨(-79141169093220961779936272298), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-94001233419362722976), 14⟩ ⟨(79141169083820838438), 4⟩ with
  | .ok v => v == ⟨(-74393675081294953307609280475), 7⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-94001233419362722976), 14⟩ ⟨(79141169083820838438), 4⟩ with
  | .ok v => v == ⟨(-1187766550678612478), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-70666503202237872350), 2⟩ ⟨(-26723323400161295688), 9⟩ with
  | .ok v => v == ⟨(-706665058745702123661295688), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-70666503202237872350), 2⟩ ⟨(-26723323400161295688), 9⟩ with
  | .ok v => v == ⟨(-706665005299055323338704312), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-70666503202237872350), 2⟩ ⟨(-26723323400161295688), 9⟩ with
  | .ok v => v == ⟨(18884438186319364687895271508), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-70666503202237872350), 2⟩ ⟨(-26723323400161295688), 9⟩ with
  | .ok v => v == ⟨(26443755570391123573798082737), 21⟩
  | .error _ => false
#guard match arithmetic .add ⟨(15621697542090493955), 4⟩ ⟨(-25158373244979912930), 11⟩ with
  | .ok v => v == ⟨(156216950262531694570087070), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(15621697542090493955), 4⟩ ⟨(-25158373244979912930), 11⟩ with
  | .ok v => v == ⟨(156217000579278184529912930), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(15621697542090493955), 4⟩ ⟨(-25158373244979912930), 11⟩ with
  | .ok v => v == ⟨(-39301649748409795035425943428), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(15621697542090493955), 4⟩ ⟨(-25158373244979912930), 11⟩ with
  | .ok v => v == ⟨(-62093432631649339004303822367), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-8454123145865021492), 13⟩ ⟨(13382602991200464602), 6⟩ with
  | .ok v => v == ⟨(133826021457881500154978508), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-8454123145865021492), 13⟩ ⟨(13382602991200464602), 6⟩ with
  | .ok v => v == ⟨(-133826038366127791885021492), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-8454123145865021492), 13⟩ ⟨(13382602991200464602), 6⟩ with
  | .ok v => v == ⟨(-11313817369983031833281330205), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-8454123145865021492), 13⟩ ⟨(13382602991200464602), 6⟩ with
  | .ok v => v == ⟨(-631724870821013434725), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(48776117218467901330), 14⟩ ⟨(74632540069528844087), 10⟩ with
  | .ok v => v == ⟨(746374176812506908771330), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(48776117218467901330), 14⟩ ⟨(74632540069528844087), 10⟩ with
  | .ok v => v == ⟨(-746276624578069972968670), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(48776117218467901330), 14⟩ ⟨(74632540069528844087), 10⟩ with
  | .ok v => v == ⟨(36402855227433414339793690286), 13⟩
  | .error _ => false
#guard match arithmetic .div ⟨(48776117218467901330), 14⟩ ⟨(74632540069528844087), 10⟩ with
  | .ok v => v == ⟨(653550276769721438309112), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-73865615141803885100), 2⟩ ⟨(79535561706593872924), 12⟩ with
  | .ok v => v == ⟨(-73865615133850328929340612708), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-73865615141803885100), 2⟩ ⟨(79535561706593872924), 12⟩ with
  | .ok v => v == ⟨(-73865615149757441270659387292), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-73865615141803885100), 2⟩ ⟨(79535561706593872924), 12⟩ with
  | .ok v => v == ⟨(-58749431911064576323689057285), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-73865615141803885100), 2⟩ ⟨(79535561706593872924), 12⟩ with
  | .ok v => v == ⟨(-9287118058497357348669894755), 18⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-56400518053036026969), 12⟩ ⟨(37242560854535304240), 7⟩ with
  | .ok v => v == ⟨(3724199684935477387973031), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-56400518053036026969), 12⟩ ⟨(37242560854535304240), 7⟩ with
  | .ok v => v == ⟨(-3724312485971583460026969), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-56400518053036026969), 12⟩ ⟨(37242560854535304240), 7⟩ with
  | .ok v => v == ⟨(-21004997258175112702993544016), 8⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-56400518053036026969), 12⟩ ⟨(37242560854535304240), 7⟩ with
  | .ok v => v == ⟨(-151441030796268982878488), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(98673889336921624967), 7⟩ ⟨(23710108425958800403), 2⟩ with
  | .ok v => v == ⟨(2371109516485216961924967), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(98673889336921624967), 7⟩ ⟨(23710108425958800403), 2⟩ with
  | .ok v => v == ⟨(-2370912168706543118675033), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(98673889336921624967), 7⟩ ⟨(23710108425958800403), 2⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(98673889336921624967), 7⟩ ⟨(23710108425958800403), 2⟩ with
  | .ok v => v == ⟨(416168022365049156418637), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(43174782854558096894), 14⟩ ⟨(50977583269638188609), 14⟩ with
  | .ok v => v == ⟨(94152366124196285503), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(43174782854558096894), 14⟩ ⟨(50977583269638188609), 14⟩ with
  | .ok v => v == ⟨(-7802800415080091715), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(43174782854558096894), 14⟩ ⟨(50977583269638188609), 14⟩ with
  | .ok v => v == ⟨(22009460881167825552258827477), 17⟩
  | .error _ => false
#guard match arithmetic .div ⟨(43174782854558096894), 14⟩ ⟨(50977583269638188609), 14⟩ with
  | .ok v => v == ⟨(846936635387198264413492704), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-28531991098276709238), 8⟩ ⟨(-79850860196741305884), 2⟩ with
  | .ok v => v == ⟨(-79850888728732404160709238), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-28531991098276709238), 8⟩ ⟨(-79850860196741305884), 2⟩ with
  | .ok v => v == ⟨(79850831664750207607290762), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-28531991098276709238), 8⟩ ⟨(-79850860196741305884), 2⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-28531991098276709238), 8⟩ ⟨(-79850860196741305884), 2⟩ with
  | .ok v => v == ⟨(35731601422925050507), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-71928840940976402664), 7⟩ ⟨(68674088275042189825), 11⟩ with
  | .ok v => v == ⟨(-719219735321488984450175), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-71928840940976402664), 7⟩ ⟨(68674088275042189825), 11⟩ with
  | .ok v => v == ⟨(-719357083498039068829825), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-71928840940976402664), 7⟩ ⟨(68674088275042189825), 11⟩ with
  | .ok v => v == ⟨(-49396475723020822064512337944), 7⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-71928840940976402664), 7⟩ ⟨(68674088275042189825), 11⟩ with
  | .ok v => v == ⟨(-10473941882256785343029403554), 24⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-29569281265466031312), 14⟩ ⟨(80164206189892387866), 11⟩ with
  | .ok v => v == ⟨(80134636908626921834688), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-29569281265466031312), 14⟩ ⟨(80164206189892387866), 11⟩ with
  | .ok v => v == ⟨(-80193775471157853897312), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-29569281265466031312), 14⟩ ⟨(80164206189892387866), 11⟩ with
  | .ok v => v == ⟨(-23703979602517410470783412011), 14⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-29569281265466031312), 14⟩ ⟨(80164206189892387866), 11⟩ with
  | .ok v => v == ⟨(-3688589043771297775242764), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-15913543946363131129), 10⟩ ⟨(57893031687760799142), 12⟩ with
  | .ok v => v == ⟨(-1533461362948552313758), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-15913543946363131129), 10⟩ ⟨(57893031687760799142), 12⟩ with
  | .ok v => v == ⟨(-1649247426324073912042), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-15913543946363131129), 10⟩ ⟨(57893031687760799142), 12⟩ with
  | .ok v => v == ⟨(-9212833039513747894403054488), 11⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-15913543946363131129), 10⟩ ⟨(57893031687760799142), 12⟩ with
  | .ok v => v == ⟨(-27487840042979512996183297347), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-62698936870432861459), 13⟩ ⟨(56847113673084365528), 1⟩ with
  | .ok v => v == ⟨(56847113673021666591129567139), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-62698936870432861459), 13⟩ ⟨(56847113673084365528), 1⟩ with
  | .ok v => v == ⟨(-56847113673147064464870432861), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-62698936870432861459), 13⟩ ⟨(56847113673084365528), 1⟩ with
  | .ok v => v == ⟨(-35642535914550373769885463649), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-62698936870432861459), 13⟩ ⟨(56847113673084365528), 1⟩ with
  | .ok v => v == ⟨(-11029396713261659), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(77820704158513495745), 9⟩ ⟨(-97492654304149887491), 2⟩ with
  | .ok v => v == ⟨(-974926465220794716396504255), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(77820704158513495745), 9⟩ ⟨(-97492654304149887491), 2⟩ with
  | .ok v => v == ⟨(974926620862203033423495745), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(77820704158513495745), 9⟩ ⟨(-97492654304149887491), 2⟩ with
  | .ok v => v == ⟨(-75869470082314758092800327906), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(77820704158513495745), 9⟩ ⟨(-97492654304149887491), 2⟩ with
  | .ok v => v == ⟨(-798221206653524947104), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-78829621892643913848), 8⟩ ⟨(30379256894213687410), 7⟩ with
  | .ok v => v == ⟨(224962947049492960252), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-78829621892643913848), 8⟩ ⟨(30379256894213687410), 7⟩ with
  | .ok v => v == ⟨(-382622190834780787948), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-78829621892643913848), 8⟩ ⟨(30379256894213687410), 7⟩ with
  | .ok v => v == ⟨(-23947853343503608453875144441), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-78829621892643913848), 8⟩ ⟨(30379256894213687410), 7⟩ with
  | .ok v => v == ⟨(-2594850235051619331486796316), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(9187983193310533543), 10⟩ ⟨(-50214909766840904706), 12⟩ with
  | .ok v => v == ⟨(868583409564212449594), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(9187983193310533543), 10⟩ ⟨(-50214909766840904706), 12⟩ with
  | .ok v => v == ⟨(969013229097894259006), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(9187983193310533543), 10⟩ ⟨(-50214909766840904706), 12⟩ with
  | .ok v => v == ⟨(-46137374699133919498496501631), 12⟩
  | .error _ => false
#guard match arithmetic .div ⟨(9187983193310533543), 10⟩ ⟨(-50214909766840904706), 12⟩ with
  | .ok v => v == ⟨(-1829732092713578791587904081), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-98971908777185260450), 7⟩ ⟨(11104761650020957259), 4⟩ with
  | .ok v => v == ⟨(11005789741243771998550), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-98971908777185260450), 7⟩ ⟨(11104761650020957259), 4⟩ with
  | .ok v => v == ⟨(-11203733558798142519450), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-98971908777185260450), 7⟩ ⟨(11104761650020957259), 4⟩ with
  | .ok v => v == ⟨(-10990594570182594551163895873), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-98971908777185260450), 7⟩ ⟨(11104761650020957259), 4⟩ with
  | .ok v => v == ⟨(-89125648885042460609028299), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(37092993046396118025), 12⟩ ⟨(65688835102705474392), 12⟩ with
  | .ok v => v == ⟨(102781828149101592417), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(37092993046396118025), 12⟩ ⟨(65688835102705474392), 12⟩ with
  | .ok v => v == ⟨(-28595842056309356367), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(37092993046396118025), 12⟩ ⟨(65688835102705474392), 12⟩ with
  | .ok v => v == ⟨(24365955036905153890340214427), 13⟩
  | .error _ => false
#guard match arithmetic .div ⟨(37092993046396118025), 12⟩ ⟨(65688835102705474392), 12⟩ with
  | .ok v => v == ⟨(5646772847836419935428839006), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-76456168948290065385), 12⟩ ⟨(36568662619443142977), 0⟩ with
  | .ok v => v == ⟨(36568662619366686808051709935), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-76456168948290065385), 12⟩ ⟨(36568662619443142977), 0⟩ with
  | .ok v => v == ⟨(-36568662619519599145948290065), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-76456168948290065385), 12⟩ ⟨(36568662619443142977), 0⟩ with
  | .ok v => v == ⟨(-27958998474451644723312755619), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-76456168948290065385), 12⟩ ⟨(36568662619443142977), 0⟩ with
  | .ok v => v == ⟨(-20907564967289558), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-32358541462375442662), 3⟩ ⟨(-16249670881664250877), 13⟩ with
  | .ok v => v == ⟨(-32358541464000409750166425088), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-32358541462375442662), 3⟩ ⟨(-16249670881664250877), 13⟩ with
  | .ok v => v == ⟨(-32358541460750475573833574912), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-32358541462375442662), 3⟩ ⟨(-16249670881664250877), 13⟩ with
  | .ok v => v == ⟨(52581564897428757725901027551), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-32358541462375442662), 3⟩ ⟨(-16249670881664250877), 13⟩ with
  | .ok v => v == ⟨(19913351906030333904607635672), 18⟩
  | .error _ => false
#guard match arithmetic .add ⟨(75255456441037438331), 1⟩ ⟨(44130117895340040223), 6⟩ with
  | .ok v => v == ⟨(7525589774221639173140223), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(75255456441037438331), 1⟩ ⟨(44130117895340040223), 6⟩ with
  | .ok v => v == ⟨(7525501513985848493059777), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(75255456441037438331), 1⟩ ⟨(44130117895340040223), 6⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(75255456441037438331), 1⟩ ⟨(44130117895340040223), 6⟩ with
  | .ok v => v == ⟨(17053083025863410718065744045), 23⟩
  | .error _ => false
#guard match arithmetic .add ⟨(69721223681789164918), 14⟩ ⟨(-80022472273634695318), 1⟩ with
  | .ok v => v == ⟨(-8002247227362772319563182108), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(69721223681789164918), 14⟩ ⟨(-80022472273634695318), 1⟩ with
  | .ok v => v == ⟨(8002247227364166744036817892), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(69721223681789164918), 14⟩ ⟨(-80022472273634695318), 1⟩ with
  | .ok v => v == ⟨(-55792646889598561589185416235), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(69721223681789164918), 14⟩ ⟨(-80022472273634695318), 1⟩ with
  | .ok v => v == ⟨(-871270553143863), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-61213753871502634998), 6⟩ ⟨(-90061502619891958458), 9⟩ with
  | .ok v => v == ⟨(-61303815374122526956458), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-61213753871502634998), 6⟩ ⟨(-90061502619891958458), 9⟩ with
  | .ok v => v == ⟨(-61123692368882743039542), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-61213753871502634998), 6⟩ ⟨(-90061502619891958458), 9⟩ with
  | .ok v => v == ⟨(55130026546717560768493950802), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-61213753871502634998), 6⟩ ⟨(-90061502619891958458), 9⟩ with
  | .ok v => v == ⟨(67968834730481503901785825835), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(73833359472506279160), 7⟩ ⟨(-31509858406637585618), 6⟩ with
  | .ok v => v == ⟨(-241265224593869577020), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(73833359472506279160), 7⟩ ⟨(-31509858406637585618), 6⟩ with
  | .ok v => v == ⟨(388931943538882135340), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(73833359472506279160), 7⟩ ⟨(-31509858406637585618), 6⟩ with
  | .ok v => v == ⟨(-23264787026650467944058026890), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(73833359472506279160), 7⟩ ⟨(-31509858406637585618), 6⟩ with
  | .ok v => v == ⟨(-2343182838833487187254844457), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(46584025820909175211), 0⟩ ⟨(-41038020916603433025), 8⟩ with
  | .ok v => v == ⟨(4658402541052896604496566975), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(46584025820909175211), 0⟩ ⟨(-41038020916603433025), 8⟩ with
  | .ok v => v == ⟨(4658402623128938437703433025), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(46584025820909175211), 0⟩ ⟨(-41038020916603433025), 8⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(46584025820909175211), 0⟩ ⟨(-41038020916603433025), 8⟩ with
  | .ok v => v == ⟨(-11351430887853050185117859697), 20⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-70178511980643160512), 9⟩ ⟨(87801254737855136651), 13⟩ with
  | .ok v => v == ⟨(-701697318551693749983349), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-70178511980643160512), 9⟩ ⟨(87801254737855136651), 13⟩ with
  | .ok v => v == ⟨(-701872921061169460256651), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-70178511980643160512), 9⟩ ⟨(87801254737855136651), 13⟩ with
  | .ok v => v == ⟨(-61617614075360687669181819145), 11⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-70178511980643160512), 9⟩ ⟨(87801254737855136651), 13⟩ with
  | .ok v => v == ⟨(-7992882583531690039561700607), 24⟩
  | .error _ => false
#guard match arithmetic .add ⟨(15093305265719428745), 10⟩ ⟨(-35298120646020758855), 11⟩ with
  | .ok v => v == ⟨(115634932011173528595), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(15093305265719428745), 10⟩ ⟨(-35298120646020758855), 11⟩ with
  | .ok v => v == ⟨(186231173303215046305), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(15093305265719428745), 10⟩ ⟨(-35298120646020758855), 11⟩ with
  | .ok v => v == ⟨(-53276531021658480356269217536), 11⟩
  | .error _ => false
#guard match arithmetic .div ⟨(15093305265719428745), 10⟩ ⟨(-35298120646020758855), 11⟩ with
  | .ok v => v == ⟨(-42759515207847001813546070943), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(67980876025122361995), 3⟩ ⟨(84066242642498035048), 10⟩ with
  | .ok v => v == ⟨(679808844317466262448035048), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(67980876025122361995), 3⟩ ⟨(84066242642498035048), 10⟩ with
  | .ok v => v == ⟨(679808676184980977451964952), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(67980876025122361995), 3⟩ ⟨(84066242642498035048), 10⟩ with
  | .ok v => v == ⟨(57148968189775138300660830556), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(67980876025122361995), 3⟩ ⟨(84066242642498035048), 10⟩ with
  | .ok v => v == ⟨(8086584327816260409001044658), 21⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-5089409144767067531), 9⟩ ⟨(-79455599386694770587), 7⟩ with
  | .ok v => v == ⟨(-7950649347814244126231), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-5089409144767067531), 9⟩ ⟨(-79455599386694770587), 7⟩ with
  | .ok v => v == ⟨(7940470529524709991169), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-5089409144767067531), 9⟩ ⟨(-79455599386694770587), 7⟩ with
  | .ok v => v == ⟨(40438205412159296780813711945), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-5089409144767067531), 9⟩ ⟨(-79455599386694770587), 7⟩ with
  | .ok v => v == ⟨(6405349886038760445173599), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-29303554891900455063), 9⟩ ⟨(37745106542354482741), 7⟩ with
  | .ok v => v == ⟨(3745207099343547819037), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-29303554891900455063), 9⟩ ⟨(37745106542354482741), 7⟩ with
  | .ok v => v == ⟨(-3803814209127348729163), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-29303554891900455063), 9⟩ ⟨(37745106542354482741), 7⟩ with
  | .ok v => v == ⟨(-11060658014645155736703431542), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-29303554891900455063), 9⟩ ⟨(37745106542354482741), 7⟩ with
  | .ok v => v == ⟨(-77635374691599806953348185), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-88489215031509383745), 4⟩ ⟨(83356522904953529301), 14⟩ with
  | .ok v => v == ⟨(-8848921502317373145450464707), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-88489215031509383745), 4⟩ ⟨(83356522904953529301), 14⟩ with
  | .ok v => v == ⟨(-8848921503984503603549535293), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-88489215031509383745), 4⟩ ⟨(83356522904953529301), 14⟩ with
  | .ok v => v == ⟨(-73761532796153700871860516311), 7⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-88489215031509383745), 4⟩ ⟨(83356522904953529301), 14⟩ with
  | .ok v => v == ⟨(-10615751706966994904695073658), 18⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-88415123884692620792), 11⟩ ⟨(-33801603671303089884), 6⟩ with
  | .ok v => v == ⟨(-3380248782254193681020792), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-88415123884692620792), 11⟩ ⟨(-33801603671303089884), 6⟩ with
  | .ok v => v == ⟨(3380071952006424295779208), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-88415123884692620792), 11⟩ ⟨(-33801603671303089884), 6⟩ with
  | .ok v => v == ⟨(29885729760995436013115352432), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-88415123884692620792), 11⟩ ⟨(-33801603671303089884), 6⟩ with
  | .ok v => v == ⟨(261570796298506266125734), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-69543795857882645120), 7⟩ ⟨(11300504535483223345), 0⟩ with
  | .ok v => v == ⟨(113004975811036375567354880), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-69543795857882645120), 7⟩ ⟨(11300504535483223345), 0⟩ with
  | .ok v => v == ⟨(-113005114898628091332645120), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-69543795857882645120), 7⟩ ⟨(11300504535483223345), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-69543795857882645120), 7⟩ ⟨(11300504535483223345), 0⟩ with
  | .ok v => v == ⟨(-6154043444654824667207), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-34041777511385075615), 5⟩ ⟨(-24196857324865558652), 14⟩ with
  | .ok v => v == ⟨(-34041777535581932939865558652), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-34041777511385075615), 5⟩ ⟨(-24196857324865558652), 14⟩ with
  | .ok v => v == ⟨(-34041777487188218290134441348), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-34041777511385075615), 5⟩ ⟨(-24196857324865558652), 14⟩ with
  | .ok v => v == ⟨(8237040335278016153335449350), 8⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-34041777511385075615), 5⟩ ⟨(-24196857324865558652), 14⟩ with
  | .ok v => v == ⟨(14068677206441401707038038103), 19⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-37063737985693023258), 2⟩ ⟨(-55300129443254427547), 12⟩ with
  | .ok v => v == ⟨(-37063737991223036202325442755), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-37063737985693023258), 2⟩ ⟨(-55300129443254427547), 12⟩ with
  | .ok v => v == ⟨(-37063737980163010313674557245), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-37063737985693023258), 2⟩ ⟨(-55300129443254427547), 12⟩ with
  | .ok v => v == ⟨(20496295082596903041677601823), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-37063737985693023258), 2⟩ ⟨(-55300129443254427547), 12⟩ with
  | .ok v => v == ⟨(67022877448642391950826745151), 19⟩
  | .error _ => false
#guard match arithmetic .add ⟨(59695396644599642808), 3⟩ ⟨(-57630511604829637927), 11⟩ with
  | .ok v => v == ⟨(5969539606829452675970362073), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(59695396644599642808), 3⟩ ⟨(-57630511604829637927), 11⟩ with
  | .ok v => v == ⟨(5969539722090475885629637927), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(59695396644599642808), 3⟩ ⟨(-57630511604829637927), 11⟩ with
  | .ok v => v == ⟨(-34402762490815079439043675474), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(59695396644599642808), 3⟩ ⟨(-57630511604829637927), 11⟩ with
  | .ok v => v == ⟨(-10358297190545322230132775117), 20⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-85897823801633968544), 7⟩ ⟨(-9972825292792864362), 9⟩ with
  | .ok v => v == ⟨(-8599755205456189718762), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-85897823801633968544), 7⟩ ⟨(-9972825292792864362), 9⟩ with
  | .ok v => v == ⟨(-8579809554870603990038), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-85897823801633968544), 7⟩ ⟨(-9972825292792864362), 9⟩ with
  | .ok v => v == ⟨(8566439898048001556876065459), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-85897823801633968544), 7⟩ ⟨(-9972825292792864362), 9⟩ with
  | .ok v => v == ⟨(861318846763618591673428443), 24⟩
  | .error _ => false
#guard match arithmetic .add ⟨(82215502918521067378), 2⟩ ⟨(-66731231712334469306), 5⟩ with
  | .ok v => v == ⟨(82148771686808732908694), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(82215502918521067378), 2⟩ ⟨(-66731231712334469306), 5⟩ with
  | .ok v => v == ⟨(82282234150233401847306), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(82215502918521067378), 2⟩ ⟨(-66731231712334469306), 5⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(82215502918521067378), 2⟩ ⟨(-66731231712334469306), 5⟩ with
  | .ok v => v == ⟨(-12320393436305254936603380077), 25⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-29000528634480619588), 4⟩ ⟨(8761604914510203724), 14⟩ with
  | .ok v => v == ⟨(-29000528633604459096548979628), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-29000528634480619588), 4⟩ ⟨(8761604914510203724), 14⟩ with
  | .ok v => v == ⟨(-29000528635356780079451020372), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-29000528634480619588), 4⟩ ⟨(8761604914510203724), 14⟩ with
  | .ok v => v == ⟨(-25409117420725928412726610235), 8⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-29000528634480619588), 4⟩ ⟨(8761604914510203724), 14⟩ with
  | .ok v => v == ⟨(-33099562143520624400937962102), 18⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-47185744001880074003), 8⟩ ⟨(-2458552745818621425), 1⟩ with
  | .ok v => v == ⟨(-24585574643930216130074003), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-47185744001880074003), 8⟩ ⟨(-2458552745818621425), 1⟩ with
  | .ok v => v == ⟨(24585480272442212369925997), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-47185744001880074003), 8⟩ ⟨(-2458552745818621425), 1⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-47185744001880074003), 8⟩ ⟨(-2458552745818621425), 1⟩ with
  | .ok v => v == ⟨(19192487971686241838315), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-4251668361953721356), 4⟩ ⟨(95199697544518406091), 6⟩ with
  | .ok v => v == ⟨(-329967138650853729509), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-4251668361953721356), 4⟩ ⟨(95199697544518406091), 6⟩ with
  | .ok v => v == ⟨(-520366533739890541691), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-4251668361953721356), 4⟩ ⟨(95199697544518406091), 6⟩ with
  | .ok v => v == ⟨(-40475754211759228079220235148), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-4251668361953721356), 4⟩ ⟨(95199697544518406091), 6⟩ with
  | .ok v => v == ⟨(-44660523842163532288091317534), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(15706280820064919123), 7⟩ ⟨(1718962003200635816), 2⟩ with
  | .ok v => v == ⟨(171911906600883646519123), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(15706280820064919123), 7⟩ ⟨(1718962003200635816), 2⟩ with
  | .ok v => v == ⟨(-171880494039243516680877), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(15706280820064919123), 7⟩ ⟨(1718962003200635816), 2⟩ with
  | .ok v => v == ⟨(26998499941290518434363957590), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(15706280820064919123), 7⟩ ⟨(1718962003200635816), 2⟩ with
  | .ok v => v == ⟨(913707271645357892339811), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-43385746977516868511), 1⟩ ⟨(-15979542231891975053), 5⟩ with
  | .ok v => v == ⟨(-433873449317400577085053), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-43385746977516868511), 1⟩ ⟨(-15979542231891975053), 5⟩ with
  | .ok v => v == ⟨(-433841490232936793134947), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-43385746977516868511), 1⟩ ⟨(-15979542231891975053), 5⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-43385746977516868511), 1⟩ ⟨(-15979542231891975053), 5⟩ with
  | .ok v => v == ⟨(27150807168260165815703607478), 24⟩
  | .error _ => false
#guard match arithmetic .add ⟨(73968233794616357650), 9⟩ ⟨(-70547967311488151934), 6⟩ with
  | .ok v => v == ⟨(-70473999077693535576350), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(73968233794616357650), 9⟩ ⟨(-70547967311488151934), 6⟩ with
  | .ok v => v == ⟨(70621935545282768291650), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(73968233794616357650), 9⟩ ⟨(-70547967311488151934), 6⟩ with
  | .ok v => v == ⟨(-52183085398311080236594909129), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(73968233794616357650), 9⟩ ⟨(-70547967311488151934), 6⟩ with
  | .ok v => v == ⟨(-10484814320450483575972371), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-49202414990039917090), 12⟩ ⟨(70163517537526517613), 8⟩ with
  | .ok v => v == ⟨(701585972960275136212910), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-49202414990039917090), 12⟩ ⟨(70163517537526517613), 8⟩ with
  | .ok v => v == ⟨(-701684377790255216047090), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-49202414990039917090), 12⟩ ⟨(70163517537526517613), 8⟩ with
  | .ok v => v == ⟨(-34522145070423233411686322433), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-49202414990039917090), 12⟩ ⟨(70163517537526517613), 8⟩ with
  | .ok v => v == ⟨(-701253539116312317197796), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(47742800860978882842), 2⟩ ⟨(-69895395405187175819), 8⟩ with
  | .ok v => v == ⟨(47742730965583477654824181), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(47742800860978882842), 2⟩ ⟨(-69895395405187175819), 8⟩ with
  | .ok v => v == ⟨(47742870756374288029175819), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(47742800860978882842), 2⟩ ⟨(-69895395405187175819), 8⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(47742800860978882842), 2⟩ ⟨(-69895395405187175819), 8⟩ with
  | .ok v => v == ⟨(-6830607450492472163963524967), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-51720323522804315422), 8⟩ ⟨(-66745348275408464705), 1⟩ with
  | .ok v => v == ⟨(-667453534474408169854315422), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-51720323522804315422), 8⟩ ⟨(-66745348275408464705), 1⟩ with
  | .ok v => v == ⟨(667453431033761124245684578), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-51720323522804315422), 8⟩ ⟨(-66745348275408464705), 1⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-51720323522804315422), 8⟩ ⟨(-66745348275408464705), 1⟩ with
  | .ok v => v == ⟨(774890308600877550529), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(38378302625725263236), 9⟩ ⟨(13414444690242282241), 2⟩ with
  | .ok v => v == ⟨(134144485280725448135263236), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(38378302625725263236), 9⟩ ⟨(13414444690242282241), 2⟩ with
  | .ok v => v == ⟨(-134144408524120196684736764), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(38378302625725263236), 9⟩ ⟨(13414444690242282241), 2⟩ with
  | .ok v => v == ⟨(51482361787817169598094931787), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(38378302625725263236), 9⟩ ⟨(13414444690242282241), 2⟩ with
  | .ok v => v == ⟨(2860968419635125529439), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-85265456659778042459), 3⟩ ⟨(-59816147679545405815), 14⟩ with
  | .ok v => v == ⟨(-8526545666037620393579545406), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-85265456659778042459), 3⟩ ⟨(-59816147679545405815), 14⟩ with
  | .ok v => v == ⟨(-8526545665917988098220454594), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-85265456659778042459), 3⟩ ⟨(-59816147679545405815), 14⟩ with
  | .ok v => v == ⟨(51002511475251617229699497236), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-85265456659778042459), 3⟩ ⟨(-59816147679545405815), 14⟩ with
  | .ok v => v == ⟨(14254588429293855147167933938), 17⟩
  | .error _ => false
#guard match arithmetic .add ⟨(75287308031656669806), 6⟩ ⟨(25169550864716164704), 5⟩ with
  | .ok v => v == ⟨(326982816678818316846), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(75287308031656669806), 6⟩ ⟨(25169550864716164704), 5⟩ with
  | .ok v => v == ⟨(-176408200615504977234), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(75287308031656669806), 6⟩ ⟨(25169550864716164704), 5⟩ with
  | .ok v => v == ⟨(18949477289703363855384182339), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(75287308031656669806), 6⟩ ⟨(25169550864716164704), 5⟩ with
  | .ok v => v == ⟨(2991205859664261418936318397), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(13270364129736462349), 2⟩ ⟨(24914490141967982519), 10⟩ with
  | .ok v => v == ⟨(1327036437888136376867982519), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(13270364129736462349), 2⟩ ⟨(24914490141967982519), 10⟩ with
  | .ok v => v == ⟨(1327036388059156092932017481), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(13270364129736462349), 2⟩ ⟨(24914490141967982519), 10⟩ with
  | .ok v => v == ⟨(33062435629064461662072774484), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(13270364129736462349), 2⟩ ⟨(24914490141967982519), 10⟩ with
  | .ok v => v == ⟨(53263639167886432377912422128), 21⟩
  | .error _ => false
#guard match arithmetic .add ⟨(42526273265431507605), 7⟩ ⟨(26852897889670670962), 8⟩ with
  | .ok v => v == ⟨(452115630543985747012), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(42526273265431507605), 7⟩ ⟨(26852897889670670962), 8⟩ with
  | .ok v => v == ⟨(398409834764644405088), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(42526273265431507605), 7⟩ ⟨(26852897889670670962), 8⟩ with
  | .ok v => v == ⟨(11419536736248640038415937764), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(42526273265431507605), 7⟩ ⟨(26852897889670670962), 8⟩ with
  | .ok v => v == ⟨(15836753798475438173406570903), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-46547210576424182475), 2⟩ ⟨(-72502949390252983716), 2⟩ with
  | .ok v => v == ⟨(-119050159966677166191), 2⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-46547210576424182475), 2⟩ ⟨(-72502949390252983716), 2⟩ with
  | .ok v => v == ⟨(25955738813828801241), 2⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-46547210576424182475), 2⟩ ⟨(-72502949390252983716), 2⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-46547210576424182475), 2⟩ ⟨(-72502949390252983716), 2⟩ with
  | .ok v => v == ⟨(6420043731721872483536307262), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(44469199472176920700), 5⟩ ⟨(-40163183780935559530), 0⟩ with
  | .ok v => v == ⟨(-4016273908894083776079300), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(44469199472176920700), 5⟩ ⟨(-40163183780935559530), 0⟩ with
  | .ok v => v == ⟨(4016362847293028129920700), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(44469199472176920700), 5⟩ ⟨(-40163183780935559530), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(44469199472176920700), 5⟩ ⟨(-40163183780935559530), 0⟩ with
  | .ok v => v == ⟨(-110721300668612126196971), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-90436551452489152569), 12⟩ ⟨(99243807133589872102), 1⟩ with
  | .ok v => v == ⟨(9924380713268550658747510847), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-90436551452489152569), 12⟩ ⟨(99243807133589872102), 1⟩ with
  | .ok v => v == ⟨(-9924380713449423761652489153), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-90436551452489152569), 12⟩ ⟨(99243807133589872102), 1⟩ with
  | .ok v => v == ⟨(-8975267670177810469035358404), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-90436551452489152569), 12⟩ ⟨(99243807133589872102), 1⟩ with
  | .ok v => v == ⟨(-91125637019098361), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-48408693022018481060), 8⟩ ⟨(-91116039692315454045), 12⟩ with
  | .ok v => v == ⟨(-484178046259877126054045), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-48408693022018481060), 8⟩ ⟨(-91116039692315454045), 12⟩ with
  | .ok v => v == ⟨(-483995814180492495145955), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-48408693022018481060), 8⟩ ⟨(-91116039692315454045), 12⟩ with
  | .ok v => v == ⟨(44108083948473500682474692374), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-48408693022018481060), 8⟩ ⟨(-91116039692315454045), 12⟩ with
  | .ok v => v == ⟨(5312861839198348537923620156), 24⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-54533145223094285209), 4⟩ ⟨(636178451673047050), 7⟩ with
  | .ok v => v == ⟨(-54532509044642612161950), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-54533145223094285209), 4⟩ ⟨(636178451673047050), 7⟩ with
  | .ok v => v == ⟨(-54533781401545958256050), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-54533145223094285209), 4⟩ ⟨(636178451673047050), 7⟩ with
  | .ok v => v == ⟨(-34692811892889544310839031791), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-54533145223094285209), 4⟩ ⟨(636178451673047050), 7⟩ with
  | .ok v => v == ⟨(-8571988736757883031457600033), 23⟩
  | .error _ => false
#guard match arithmetic .add ⟨(35291594681340458459), 7⟩ ⟨(-97428508353816135036), 7⟩ with
  | .ok v => v == ⟨(-62136913672475676577), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(35291594681340458459), 7⟩ ⟨(-97428508353816135036), 7⟩ with
  | .ok v => v == ⟨(132720103035156593495), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(35291594681340458459), 7⟩ ⟨(-97428508353816135036), 7⟩ with
  | .ok v => v == ⟨(-34384074272304719371052842116), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(35291594681340458459), 7⟩ ⟨(-97428508353816135036), 7⟩ with
  | .ok v => v == ⟨(-3622306784496525372068290604), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-93373289415568980348), 9⟩ ⟨(-67811734818506866300), 1⟩ with
  | .ok v => v == ⟨(-6781173575223976045568980348), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-93373289415568980348), 9⟩ ⟨(-67811734818506866300), 1⟩ with
  | .ok v => v == ⟨(6781173388477397214431019652), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-93373289415568980348), 9⟩ ⟨(-67811734818506866300), 1⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-93373289415568980348), 9⟩ ⟨(-67811734818506866300), 1⟩ with
  | .ok v => v == ⟨(137694883732846150861), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(76811207100307606499), 8⟩ ⟨(-59400412738197654592), 3⟩ with
  | .ok v => v == ⟨(-5939964462612665151593501), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(76811207100307606499), 8⟩ ⟨(-59400412738197654592), 3⟩ with
  | .ok v => v == ⟨(5940118085026865766806499), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(76811207100307606499), 8⟩ ⟨(-59400412738197654592), 3⟩ with
  | .ok v => v == ⟨(-45626174046774500806019299873), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(76811207100307606499), 8⟩ ⟨(-59400412738197654592), 3⟩ with
  | .ok v => v == ⟨(-129310897954272759368578), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(64005698686457467685), 8⟩ ⟨(-57981333310467661356), 0⟩ with
  | .ok v => v == ⟨(-5798133267041067449142532315), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(64005698686457467685), 8⟩ ⟨(-57981333310467661356), 0⟩ with
  | .ok v => v == ⟨(5798133395052464822057467685), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(64005698686457467685), 8⟩ ⟨(-57981333310467661356), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(64005698686457467685), 8⟩ ⟨(-57981333310467661356), 0⟩ with
  | .ok v => v == ⟨(-110390180825493706586), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(41206520471217749556), 9⟩ ⟨(-84397999802734646342), 10⟩ with
  | .ok v => v == ⟨(327667204909442849218), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(41206520471217749556), 9⟩ ⟨(-84397999802734646342), 10⟩ with
  | .ok v => v == ⟨(496463204514912141902), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(41206520471217749556), 9⟩ ⟨(-84397999802734646342), 10⟩ with
  | .ok v => v == ⟨(-34777479066012167932569018239), 8⟩
  | .error _ => false
#guard match arithmetic .div ⟨(41206520471217749556), 9⟩ ⟨(-84397999802734646342), 10⟩ with
  | .ok v => v == ⟨(-4882404863566752976054346846), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-26190937939041115931), 10⟩ ⟨(-36764774546090243574), 7⟩ with
  | .ok v => v == ⟨(-36790965484029284689931), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-26190937939041115931), 10⟩ ⟨(-36764774546090243574), 7⟩ with
  | .ok v => v == ⟨(36738583608151202458069), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-26190937939041115931), 10⟩ ⟨(-36764774546090243574), 7⟩ with
  | .ok v => v == ⟨(9629039284794880824734951568), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-26190937939041115931), 10⟩ ⟨(-36764774546090243574), 7⟩ with
  | .ok v => v == ⟨(712392181440057160372752), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(23412842901115433033), 12⟩ ⟨(-32845141586117427897), 11⟩ with
  | .ok v => v == ⟨(-305038572960058845937), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(23412842901115433033), 12⟩ ⟨(-32845141586117427897), 11⟩ with
  | .ok v => v == ⟨(351864258762289712003), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(23412842901115433033), 12⟩ ⟨(-32845141586117427897), 11⟩ with
  | .ok v => v == ⟨(-76899814002066071620325577459), 13⟩
  | .error _ => false
#guard match arithmetic .div ⟨(23412842901115433033), 12⟩ ⟨(-32845141586117427897), 11⟩ with
  | .ok v => v == ⟨(-712825147662364760280235805), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(97718336066913388412), 9⟩ ⟨(90219144209776498532), 3⟩ with
  | .ok v => v == ⟨(90219241928112565445388412), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(97718336066913388412), 9⟩ ⟨(90219144209776498532), 3⟩ with
  | .ok v => v == ⟨(-90219046491440431618611588), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(97718336066913388412), 9⟩ ⟨(90219144209776498532), 3⟩ with
  | .ok v => v == ⟨(8816064653560263007160498406), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(97718336066913388412), 9⟩ ⟨(90219144209776498532), 3⟩ with
  | .ok v => v == ⟨(10831219573497600100932), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(68316137640345154824), 8⟩ ⟨(53205781976489204971), 14⟩ with
  | .ok v => v == ⟨(68316190846127131313204971), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(68316137640345154824), 8⟩ ⟨(53205781976489204971), 14⟩ with
  | .ok v => v == ⟨(68316084434563178334795029), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(68316137640345154824), 8⟩ ⟨(53205781976489204971), 14⟩ with
  | .ok v => v == ⟨(36348135247680320030868857121), 11⟩
  | .error _ => false
#guard match arithmetic .div ⟨(68316137640345154824), 8⟩ ⟨(53205781976489204971), 14⟩ with
  | .ok v => v == ⟨(1283998375788048326302613512), 21⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-35752034660101807421), 7⟩ ⟨(84157411018035231946), 4⟩ with
  | .ok v => v == ⟨(84121658983375130138579), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-35752034660101807421), 7⟩ ⟨(84157411018035231946), 4⟩ with
  | .ok v => v == ⟨(-84193163052695333753421), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-35752034660101807421), 7⟩ ⟨(84157411018035231946), 4⟩ with
  | .ok v => v == ⟨(-30087986756212293466083143998), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-35752034660101807421), 7⟩ ⟨(84157411018035231946), 4⟩ with
  | .ok v => v == ⟨(-4248233664464799121619507), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-69417149229918046306), 14⟩ ⟨(79177609250932284766), 3⟩ with
  | .ok v => v == ⟨(79177609250238113273700819537), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-69417149229918046306), 14⟩ ⟨(79177609250932284766), 3⟩ with
  | .ok v => v == ⟨(-79177609251626456258299180463), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-69417149229918046306), 14⟩ ⟨(79177609250932284766), 3⟩ with
  | .ok v => v == ⟨(-54962839170401060306660751565), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-69417149229918046306), 14⟩ ⟨(79177609250932284766), 3⟩ with
  | .ok v => v == ⟨(-8767270177345079), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(95704141150759724122), 0⟩ ⟨(-94223370126029497708), 9⟩ with
  | .ok v => v == ⟨(9570414105653635399597050229), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(95704141150759724122), 0⟩ ⟨(-94223370126029497708), 9⟩ with
  | .ok v => v == ⟨(9570414124498309424802949771), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(95704141150759724122), 0⟩ ⟨(-94223370126029497708), 9⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(95704141150759724122), 0⟩ ⟨(-94223370126029497708), 9⟩ with
  | .ok v => v == ⟨(-10157155387538102803863487592), 19⟩
  | .error _ => false
#guard match arithmetic .add ⟨(30178289977914486315), 11⟩ ⟨(-14951118099221396196), 14⟩ with
  | .ok v => v == ⟨(30163338859815264918804), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(30178289977914486315), 11⟩ ⟨(-14951118099221396196), 14⟩ with
  | .ok v => v == ⟨(30193241096013707711196), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(30178289977914486315), 11⟩ ⟨(-14951118099221396196), 14⟩ with
  | .ok v => v == ⟨(-45119917749234894522137950647), 15⟩
  | .error _ => false
#guard match arithmetic .div ⟨(30178289977914486315), 11⟩ ⟨(-14951118099221396196), 14⟩ with
  | .ok v => v == ⟨(-20184637548603184314870984411), 25⟩
  | .error _ => false
#guard match arithmetic .add ⟨(30866541194390168685), 2⟩ ⟨(-16914769122940661503), 14⟩ with
  | .ok v => v == ⟨(30866541194373253915877059338), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(30866541194390168685), 2⟩ ⟨(-16914769122940661503), 14⟩ with
  | .ok v => v == ⟨(30866541194407083454122940662), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(30866541194390168685), 2⟩ ⟨(-16914769122940661503), 14⟩ with
  | .ok v => v == ⟨(-52210041792684679192573581581), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(30866541194390168685), 2⟩ ⟨(-16914769122940661503), 14⟩ with
  | .ok v => v == ⟨(-18248278158598932018586866304), 16⟩
  | .error _ => false
#guard match arithmetic .add ⟨(17238207788756573351), 3⟩ ⟨(53119683661786498504), 0⟩ with
  | .ok v => v == ⟨(53136921869575255077351), 3⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(17238207788756573351), 3⟩ ⟨(53119683661786498504), 0⟩ with
  | .ok v => v == ⟨(-53102445453997741930649), 3⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(17238207788756573351), 3⟩ ⟨(53119683661786498504), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(17238207788756573351), 3⟩ ⟨(53119683661786498504), 0⟩ with
  | .ok v => v == ⟨(3245163864023060959653462), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(26857749233276321681), 2⟩ ⟨(90528251900683318895), 11⟩ with
  | .ok v => v == ⟨(26857749323804573581683318895), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(26857749233276321681), 2⟩ ⟨(90528251900683318895), 11⟩ with
  | .ok v => v == ⟨(26857749142748069780316681105), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(26857749233276321681), 2⟩ ⟨(90528251900683318895), 11⟩ with
  | .ok v => v == ⟨(24313850880754231189712689173), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(26857749233276321681), 2⟩ ⟨(90528251900683318895), 11⟩ with
  | .ok v => v == ⟨(29667809406881517319556450158), 20⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-24877264696962512936), 12⟩ ⟨(14626377850998841801), 1⟩ with
  | .ok v => v == ⟨(14626377850750069154030374871), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-24877264696962512936), 12⟩ ⟨(14626377850998841801), 1⟩ with
  | .ok v => v == ⟨(-14626377851247614447969625129), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-24877264696962512936), 12⟩ ⟨(14626377850998841801), 1⟩ with
  | .ok v => v == ⟨(-36386427335708791336131662325), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-24877264696962512936), 12⟩ ⟨(14626377850998841801), 1⟩ with
  | .ok v => v == ⟨(-170084931145571585), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-67205653853162222520), 10⟩ ⟨(23114966257454438546), 6⟩ with
  | .ok v => v == ⟨(231082456920691223237480), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-67205653853162222520), 10⟩ ⟨(23114966257454438546), 6⟩ with
  | .ok v => v == ⟨(-231216868228397547682520), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-67205653853162222520), 10⟩ ⟨(23114966257454438546), 6⟩ with
  | .ok v => v == ⟨(-15534564211260076459169358455), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-67205653853162222520), 10⟩ ⟨(23114966257454438546), 6⟩ with
  | .ok v => v == ⟨(-2907451955785953206405659), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(45195456891237536302), 3⟩ ⟨(-1611227569889001459), 7⟩ with
  | .ok v => v == ⟨(451952957684805474018541), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(45195456891237536302), 3⟩ ⟨(-1611227569889001459), 7⟩ with
  | .ok v => v == ⟨(451956180139945252021459), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(45195456891237536302), 3⟩ ⟨(-1611227569889001459), 7⟩ with
  | .ok v => v == ⟨(-72820166176891780133902483926), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(45195456891237536302), 3⟩ ⟨(-1611227569889001459), 7⟩ with
  | .ok v => v == ⟨(-28050324942212279451723552826), 23⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-16976928955651052938), 4⟩ ⟨(65597254793450968484), 0⟩ with
  | .ok v => v == ⟨(655955571005554033787062), 4⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-16976928955651052938), 4⟩ ⟨(65597254793450968484), 0⟩ with
  | .ok v => v == ⟨(-655989524863465335892938), 4⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-16976928955651052938), 4⟩ ⟨(65597254793450968484), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-16976928955651052938), 4⟩ ⟨(65597254793450968484), 0⟩ with
  | .ok v => v == ⟨(-25880547911809837166018), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-49820015437477074589), 4⟩ ⟨(-51126501490010513185), 10⟩ with
  | .ok v => v == ⟨(-49820066563978564599513185), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-49820015437477074589), 4⟩ ⟨(-51126501490010513185), 10⟩ with
  | .ok v => v == ⟨(-49819964310975584578486815), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-49820015437477074589), 4⟩ ⟨(-51126501490010513185), 10⟩ with
  | .ok v => v == ⟨(25471230934965184228543466900), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-49820015437477074589), 4⟩ ⟨(-51126501490010513185), 10⟩ with
  | .ok v => v == ⟨(9744460110811863426372887037), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(11090674028579064675), 9⟩ ⟨(69974339655057732226), 6⟩ with
  | .ok v => v == ⟨(69985430329086311290675), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(11090674028579064675), 9⟩ ⟨(69974339655057732226), 6⟩ with
  | .ok v => v == ⟨(-69963248981029153161325), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(11090674028579064675), 9⟩ ⟨(69974339655057732226), 6⟩ with
  | .ok v => v == ⟨(77606259147931893789017244415), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(11090674028579064675), 9⟩ ⟨(69974339655057732226), 6⟩ with
  | .ok v => v == ⟨(1584963014049312693111277), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-40849057345644487531), 11⟩ ⟨(89730918669013292827), 5⟩ with
  | .ok v => v == ⟨(89730877819955947182512469), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-40849057345644487531), 11⟩ ⟨(89730918669013292827), 5⟩ with
  | .ok v => v == ⟨(-89730959518070638471487531), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-40849057345644487531), 11⟩ ⟨(89730918669013292827), 5⟩ with
  | .ok v => v == ⟨(-36654234423878855314847543476), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-40849057345644487531), 11⟩ ⟨(89730918669013292827), 5⟩ with
  | .ok v => v == ⟨(-455239486584581911735), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(80628372921023446970), 6⟩ ⟨(-33667363192888011160), 14⟩ with
  | .ok v => v == ⟨(8062837258434981504111988840), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(80628372921023446970), 6⟩ ⟨(-33667363192888011160), 14⟩ with
  | .ok v => v == ⟨(8062837325769707889888011160), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(80628372921023446970), 6⟩ ⟨(-33667363192888011160), 14⟩ with
  | .ok v => v == ⟨(-27145447147837132164532525478), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(80628372921023446970), 6⟩ ⟨(-33667363192888011160), 14⟩ with
  | .ok v => v == ⟨(-23948526191102370639633809139), 20⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-42582442299937570490), 7⟩ ⟨(78437448470934547346), 3⟩ with
  | .ok v => v == ⟨(784331902267045535889510), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-42582442299937570490), 7⟩ ⟨(78437448470934547346), 3⟩ with
  | .ok v => v == ⟨(-784417067151645411030490), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-42582442299937570490), 7⟩ ⟨(78437448470934547346), 3⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-42582442299937570490), 7⟩ ⟨(78437448470934547346), 3⟩ with
  | .ok v => v == ⟨(-542884083177651324369765), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-44872281836871964868), 7⟩ ⟨(90538379410086807939), 5⟩ with
  | .ok v => v == ⟨(9008965659171808829032), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-44872281836871964868), 7⟩ ⟨(90538379410086807939), 5⟩ with
  | .ok v => v == ⟨(-9098710222845552758768), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-44872281836871964868), 7⟩ ⟨(90538379410086807939), 5⟩ with
  | .ok v => v == ⟨(-40626636779430609531156605574), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-44872281836871964868), 7⟩ ⟨(90538379410086807939), 5⟩ with
  | .ok v => v == ⟨(-49561613681670096344203827), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(93274216161891241045), 1⟩ ⟨(-76164953125427547449), 10⟩ with
  | .ok v => v == ⟨(9327421608572628791957245255), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(93274216161891241045), 1⟩ ⟨(-76164953125427547449), 10⟩ with
  | .ok v => v == ⟨(9327421623805619417042754745), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(93274216161891241045), 1⟩ ⟨(-76164953125427547449), 10⟩ with
  | .ok v => v == ⟨(-71042263017814429387179921867), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(93274216161891241045), 1⟩ ⟨(-76164953125427547449), 10⟩ with
  | .ok v => v == ⟨(-12246343276583963861298814721), 19⟩
  | .error _ => false
#guard match arithmetic .add ⟨(62055503474261385342), 10⟩ ⟨(-87788544935270654759), 6⟩ with
  | .ok v => v == ⟨(-877823393849232286204658), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(62055503474261385342), 10⟩ ⟨(-87788544935270654759), 6⟩ with
  | .ok v => v == ⟨(877947504856180808975342), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(62055503474261385342), 10⟩ ⟨(-87788544935270654759), 6⟩ with
  | .ok v => v == ⟨(-54477623552310398603689672207), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(62055503474261385342), 10⟩ ⟨(-87788544935270654759), 6⟩ with
  | .ok v => v == ⟨(-706874724031670913283534), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-9014742909268925162), 14⟩ ⟨(-26103110753630616070), 6⟩ with
  | .ok v => v == ⟨(-2610311084377804516268925162), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-9014742909268925162), 14⟩ ⟨(-26103110753630616070), 6⟩ with
  | .ok v => v == ⟨(2610311066348318697731074838), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-9014742909268925162), 14⟩ ⟨(-26103110753630616070), 6⟩ with
  | .ok v => v == ⟨(23531283257615302551045800314), 10⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-9014742909268925162), 14⟩ ⟨(-26103110753630616070), 6⟩ with
  | .ok v => v == ⟨(34535128760525552409), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-75656299679835548014), 3⟩ ⟨(-63792912042279625002), 9⟩ with
  | .ok v => v == ⟨(-75656363472747590293625002), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-75656299679835548014), 3⟩ ⟨(-63792912042279625002), 9⟩ with
  | .ok v => v == ⟨(-75656235886923505734374998), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-75656299679835548014), 3⟩ ⟨(-63792912042279625002), 9⟩ with
  | .ok v => v == ⟨(48263356709200972684312563991), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-75656299679835548014), 3⟩ ⟨(-63792912042279625002), 9⟩ with
  | .ok v => v == ⟨(11859671750004655782181413223), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(49583686038002811071), 13⟩ ⟨(21581306289046348602), 11⟩ with
  | .ok v => v == ⟨(2207714314942637671271), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(49583686038002811071), 13⟩ ⟨(21581306289046348602), 11⟩ with
  | .ok v => v == ⟨(-2108546942866632049129), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(49583686038002811071), 13⟩ ⟨(21581306289046348602), 11⟩ with
  | .ok v => v == ⟨(10700807153260496940961194747), 13⟩
  | .error _ => false
#guard match arithmetic .div ⟨(49583686038002811071), 13⟩ ⟨(21581306289046348602), 11⟩ with
  | .ok v => v == ⟨(229752941614888007831784048), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-33483443824454079091), 3⟩ ⟨(-89569148636994414333), 11⟩ with
  | .ok v => v == ⟨(-3348344472014556546094414333), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-33483443824454079091), 3⟩ ⟨(-89569148636994414333), 11⟩ with
  | .ok v => v == ⟨(-3348344292876259272105585667), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-33483443824454079091), 3⟩ ⟨(-89569148636994414333), 11⟩ with
  | .ok v => v == ⟨(29990835567909801181155162420), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-33483443824454079091), 3⟩ ⟨(-89569148636994414333), 11⟩ with
  | .ok v => v == ⟨(37382786745194690924259685407), 21⟩
  | .error _ => false
#guard match arithmetic .add ⟨(4411472946770105703), 11⟩ ⟨(-61343051464128255971), 14⟩ with
  | .ok v => v == ⟨(4350129895305977447029), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(4411472946770105703), 11⟩ ⟨(-61343051464128255971), 14⟩ with
  | .ok v => v == ⟨(4472815998234233958971), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(4411472946770105703), 11⟩ ⟨(-61343051464128255971), 14⟩ with
  | .ok v => v == ⟨(-27061321200632812446217713041), 15⟩
  | .error _ => false
#guard match arithmetic .div ⟨(4411472946770105703), 11⟩ ⟨(-61343051464128255971), 14⟩ with
  | .ok v => v == ⟨(-71914794609619555804692593209), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(98085439475888310936), 4⟩ ⟨(28724076373202685953), 4⟩ with
  | .ok v => v == ⟨(126809515849090996889), 4⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(98085439475888310936), 4⟩ ⟨(28724076373202685953), 4⟩ with
  | .ok v => v == ⟨(69361363102685624983), 4⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(98085439475888310936), 4⟩ ⟨(28724076373202685953), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(98085439475888310936), 4⟩ ⟨(28724076373202685953), 4⟩ with
  | .ok v => v == ⟨(34147465074767154388904903886), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-36988762554725920162), 13⟩ ⟨(45241291210438759360), 8⟩ with
  | .ok v => v == ⟨(4524092132281321210079838), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-36988762554725920162), 13⟩ ⟨(45241291210438759360), 8⟩ with
  | .ok v => v == ⟨(-4524166109806430661920162), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-36988762554725920162), 13⟩ ⟨(45241291210438759360), 8⟩ with
  | .ok v => v == ⟨(-16734193782521280815699558857), 10⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-36988762554725920162), 13⟩ ⟨(45241291210438759360), 8⟩ with
  | .ok v => v == ⟨(-81758856931544230177563), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-72249772712349445256), 10⟩ ⟨(-47884698054290936644), 12⟩ with
  | .ok v => v == ⟨(-7272861969289235462244), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-72249772712349445256), 10⟩ ⟨(-47884698054290936644), 12⟩ with
  | .ok v => v == ⟨(-7177092573180653588956), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-72249772712349445256), 10⟩ ⟨(-47884698054290936644), 12⟩ with
  | .ok v => v == ⟨(34596585508220018894206564568), 11⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-72249772712349445256), 10⟩ ⟨(-47884698054290936644), 12⟩ with
  | .ok v => v == ⟨(15088279899026148280083810206), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(10140446795632120406), 13⟩ ⟨(66265038680243237847), 10⟩ with
  | .ok v => v == ⟨(66275179127038869967406), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(10140446795632120406), 13⟩ ⟨(66265038680243237847), 10⟩ with
  | .ok v => v == ⟨(-66254898233447605726594), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(10140446795632120406), 13⟩ ⟨(66265038680243237847), 10⟩ with
  | .ok v => v == ⟨(67195709914751105420019491005), 13⟩
  | .error _ => false
#guard match arithmetic .div ⟨(10140446795632120406), 13⟩ ⟨(66265038680243237847), 10⟩ with
  | .ok v => v == ⟨(1530286105251375981879449), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(91755132841228533535), 12⟩ ⟨(62415689550373538928), 13⟩ with
  | .ok v => v == ⟨(979967017962658874278), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(91755132841228533535), 12⟩ ⟨(62415689550373538928), 13⟩ with
  | .ok v => v == ⟨(855135638861911796422), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(91755132841228533535), 12⟩ ⟨(62415689550373538928), 13⟩ with
  | .ok v => v == ⟨(57269598860714037036823341599), 14⟩
  | .error _ => false
#guard match arithmetic .div ⟨(91755132841228533535), 12⟩ ⟨(62415689550373538928), 13⟩ with
  | .ok v => v == ⟨(1470065195181031320640147711), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-20967783176959054562), 9⟩ ⟨(-20019400431823601441), 3⟩ with
  | .ok v => v == ⟨(-20019421399606778400054562), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-20967783176959054562), 9⟩ ⟨(-20019400431823601441), 3⟩ with
  | .ok v => v == ⟨(20019379464040424481945438), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-20967783176959054562), 9⟩ ⟨(-20019400431823601441), 3⟩ with
  | .ok v => v == ⟨(41976244758719774260697435156), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-20967783176959054562), 9⟩ ⟨(-20019400431823601441), 3⟩ with
  | .ok v => v == ⟨(10473731842452118489318), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-22745448010334202406), 3⟩ ⟨(23798328092802833058), 7⟩ with
  | .ok v => v == ⟨(-227430681775249221226942), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-22745448010334202406), 3⟩ ⟨(23798328092802833058), 7⟩ with
  | .ok v => v == ⟨(-227478278431434826893058), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-22745448010334202406), 3⟩ ⟨(23798328092802833058), 7⟩ with
  | .ok v => v == ⟨(-54130363436772275300884041267), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-22745448010334202406), 3⟩ ⟨(23798328092802833058), 7⟩ with
  | .ok v => v == ⟨(-9557582331681927675542234798), 24⟩
  | .error _ => false
#guard match arithmetic .add ⟨(31408081005320963052), 14⟩ ⟨(7834508549670038914), 11⟩ with
  | .ok v => v == ⟨(7865916630675359877052), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(31408081005320963052), 14⟩ ⟨(7834508549670038914), 11⟩ with
  | .ok v => v == ⟨(-7803100468664717950948), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(31408081005320963052), 14⟩ ⟨(7834508549670038914), 11⟩ with
  | .ok v => v == ⟨(24606687916491623600743641785), 15⟩
  | .error _ => false
#guard match arithmetic .div ⟨(31408081005320963052), 14⟩ ⟨(7834508549670038914), 11⟩ with
  | .ok v => v == ⟨(40089408041610673222700994), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-8548469911010277013), 12⟩ ⟨(-1949356340931447959), 7⟩ with
  | .ok v => v == ⟨(-194944182563055806177013), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-8548469911010277013), 12⟩ ⟨(-1949356340931447959), 7⟩ with
  | .ok v => v == ⟨(194927085623233785622987), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-8548469911010277013), 12⟩ ⟨(-1949356340931447959), 7⟩ with
  | .ok v => v == ⟨(16664014026289574151631246572), 10⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-8548469911010277013), 12⟩ ⟨(-1949356340931447959), 7⟩ with
  | .ok v => v == ⟨(438527822313165101585115), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(97124685546354903475), 3⟩ ⟨(-10076777897577451564), 12⟩ with
  | .ok v => v == ⟨(9712468553627812557742254844), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(97124685546354903475), 3⟩ ⟨(-10076777897577451564), 12⟩ with
  | .ok v => v == ⟨(9712468555643168137257745156), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(97124685546354903475), 3⟩ ⟨(-10076777897577451564), 12⟩ with
  | .ok v => v == ⟨(-9787038846226692618261993256), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(97124685546354903475), 3⟩ ⟨(-10076777897577451564), 12⟩ with
  | .ok v => v == ⟨(-9638466435754682582055916978), 18⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-97224107581251349767), 10⟩ ⟨(-23909750096149433494), 2⟩ with
  | .ok v => v == ⟨(-2390975106839050930651349767), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-97224107581251349767), 10⟩ ⟨(-23909750096149433494), 2⟩ with
  | .ok v => v == ⟨(2390974912390835768148650233), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-97224107581251349767), 10⟩ ⟨(-23909750096149433494), 2⟩ with
  | .ok v => v == ⟨(23246041155888673259885561057), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-97224107581251349767), 10⟩ ⟨(-23909750096149433494), 2⟩ with
  | .ok v => v == ⟨(406629543137336641417), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(57152927077599854461), 9⟩ ⟨(66661833691577183825), 2⟩ with
  | .ok v => v == ⟨(666618394068698915849854461), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(57152927077599854461), 9⟩ ⟨(66661833691577183825), 2⟩ with
  | .ok v => v == ⟨(-666618279762844760650145539), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(57152927077599854461), 9⟩ ⟨(66661833691577183825), 2⟩ with
  | .ok v => v == ⟨(38099189198337998945855816014), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(57152927077599854461), 9⟩ ⟨(66661833691577183825), 2⟩ with
  | .ok v => v == ⟨(857356059871200436987), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-79062576263443070465), 0⟩ ⟨(-67909050376993964740), 4⟩ with
  | .ok v => v == ⟨(-790693671684807698614740), 4⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-79062576263443070465), 0⟩ ⟨(-67909050376993964740), 4⟩ with
  | .ok v => v == ⟨(-790557853584053710685260), 4⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-79062576263443070465), 0⟩ ⟨(-67909050376993964740), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-79062576263443070465), 0⟩ ⟨(-67909050376993964740), 4⟩ with
  | .ok v => v == ⟨(11642421124214051085382829901), 24⟩
  | .error _ => false
#guard match arithmetic .add ⟨(32687687007168380151), 6⟩ ⟨(-18244321074271464022), 8⟩ with
  | .ok v => v == ⟨(3250524379642566551078), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(32687687007168380151), 6⟩ ⟨(-18244321074271464022), 8⟩ with
  | .ok v => v == ⟨(3287013021791109479122), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(32687687007168380151), 6⟩ ⟨(-18244321074271464022), 8⟩ with
  | .ok v => v == ⟨(-59636465693407159804017567348), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(32687687007168380151), 6⟩ ⟨(-18244321074271464022), 8⟩ with
  | .ok v => v == ⟨(-17916636565481881920492560937), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-98483942749609190580), 14⟩ ⟨(92052599336664046315), 12⟩ with
  | .ok v => v == ⟨(9106775990916795440920), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-98483942749609190580), 14⟩ ⟨(92052599336664046315), 12⟩ with
  | .ok v => v == ⟨(-9303743876416013822080), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-98483942749609190580), 14⟩ ⟨(92052599336664046315), 12⟩ with
  | .ok v => v == ⟨(-9065702923024734890313554406), 14⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-98483942749609190580), 14⟩ ⟨(92052599336664046315), 12⟩ with
  | .ok v => v == ⟨(-106986596206179672099845042), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(31029218876055206641), 2⟩ ⟨(85946421878855312339), 1⟩ with
  | .ok v => v == ⟨(890493437664608330031), 2⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(31029218876055206641), 2⟩ ⟨(85946421878855312339), 1⟩ with
  | .ok v => v == ⟨(-828434999912497916749), 2⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(31029218876055206641), 2⟩ ⟨(85946421878855312339), 1⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(31029218876055206641), 2⟩ ⟨(85946421878855312339), 1⟩ with
  | .ok v => v == ⟨(361029792721237983781686069), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(46861549550413453353), 1⟩ ⟨(-31897466661251705208), 4⟩ with
  | .ok v => v == ⟨(46829652083752201647792), 4⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(46861549550413453353), 1⟩ ⟨(-31897466661251705208), 4⟩ with
  | .ok v => v == ⟨(46893447017074705058208), 4⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(46861549550413453353), 1⟩ ⟨(-31897466661251705208), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(46861549550413453353), 1⟩ ⟨(-31897466661251705208), 4⟩ with
  | .ok v => v == ⟨(-14691307635204699583834728064), 25⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-30268515217799620048), 4⟩ ⟨(-90089350967466714937), 10⟩ with
  | .ok v => v == ⟨(-30268605307150587514714937), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-30268515217799620048), 4⟩ ⟨(-90089350967466714937), 10⟩ with
  | .ok v => v == ⟨(-30268425128448652581285063), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-30268515217799620048), 4⟩ ⟨(-90089350967466714937), 10⟩ with
  | .ok v => v == ⟨(27268708907204571841564802774), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-30268515217799620048), 4⟩ ⟨(-90089350967466714937), 10⟩ with
  | .ok v => v == ⟨(33598327541209903624882653162), 23⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-9308111925679712408), 5⟩ ⟨(-7819511706525041928), 3⟩ with
  | .ok v => v == ⟨(-791259282578183905208), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-9308111925679712408), 5⟩ ⟨(-7819511706525041928), 3⟩ with
  | .ok v => v == ⟨(772643058726824480392), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-9308111925679712408), 5⟩ ⟨(-7819511706525041928), 3⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-9308111925679712408), 5⟩ ⟨(-7819511706525041928), 3⟩ with
  | .ok v => v == ⟨(119036997130044558094752079), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(29770758012997197553), 8⟩ ⟨(-57136544043714961879), 8⟩ with
  | .ok v => v == ⟨(-27365786030717764326), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(29770758012997197553), 8⟩ ⟨(-57136544043714961879), 8⟩ with
  | .ok v => v == ⟨(86907302056712159432), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(29770758012997197553), 8⟩ ⟨(-57136544043714961879), 8⟩ with
  | .ok v => v == ⟨(-17009982264243945015107831096), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(29770758012997197553), 8⟩ ⟨(-57136544043714961879), 8⟩ with
  | .ok v => v == ⟨(-5210458299721400538078743775), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(83390650523184408163), 5⟩ ⟨(57231428645814194999), 13⟩ with
  | .ok v => v == ⟨(8339065109549869462114194999), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(83390650523184408163), 5⟩ ⟨(57231428645814194999), 13⟩ with
  | .ok v => v == ⟨(8339064995087012170485805001), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(83390650523184408163), 5⟩ ⟨(57231428645814194999), 13⟩ with
  | .ok v => v == ⟨(47725660651456566245766235078), 7⟩
  | .error _ => false
#guard match arithmetic .div ⟨(83390650523184408163), 5⟩ ⟨(57231428645814194999), 13⟩ with
  | .ok v => v == ⟨(14570779114961592378803435432), 20⟩
  | .error _ => false
#guard match arithmetic .add ⟨(98082716679353156737), 11⟩ ⟨(22997200668304193759), 12⟩ with
  | .ok v => v == ⟨(1003824367461835761129), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(98082716679353156737), 11⟩ ⟨(22997200668304193759), 12⟩ with
  | .ok v => v == ⟨(957829966125227373611), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(98082716679353156737), 11⟩ ⟨(22997200668304193759), 12⟩ with
  | .ok v => v == ⟨(22556279175675113081996695348), 12⟩
  | .error _ => false
#guard match arithmetic .div ⟨(98082716679353156737), 11⟩ ⟨(22997200668304193759), 12⟩ with
  | .ok v => v == ⟨(42649850342235477382477391255), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-46456665274006735449), 12⟩ ⟨(22180947641254874012), 7⟩ with
  | .ok v => v == ⟨(2218048307460213394464551), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-46456665274006735449), 12⟩ ⟨(22180947641254874012), 7⟩ with
  | .ok v => v == ⟨(-2218141220790761407935449), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-46456665274006735449), 12⟩ ⟨(22180947641254874012), 7⟩ with
  | .ok v => v == ⟨(-10304528600300469139381348018), 8⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-46456665274006735449), 12⟩ ⟨(22180947641254874012), 7⟩ with
  | .ok v => v == ⟨(-209444005844010355591695), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-4960110514194643383), 8⟩ ⟨(4684676095864888426), 7⟩ with
  | .ok v => v == ⟨(41886650444454240877), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-4960110514194643383), 8⟩ ⟨(4684676095864888426), 7⟩ with
  | .ok v => v == ⟨(-51806871472843527643), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-4960110514194643383), 8⟩ ⟨(4684676095864888426), 7⟩ with
  | .ok v => v == ⟨(-23236511158695746208797885158), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-4960110514194643383), 8⟩ ⟨(4684676095864888426), 7⟩ with
  | .ok v => v == ⟨(-1058794762475228086697796791), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-42762798741235107391), 9⟩ ⟨(-97831021901551225234), 13⟩ with
  | .ok v => v == ⟨(-427725818434252625135234), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-42762798741235107391), 9⟩ ⟨(-97831021901551225234), 13⟩ with
  | .ok v => v == ⟨(-427530156390449522684766), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-42762798741235107391), 9⟩ ⟨(-97831021901551225234), 13⟩ with
  | .ok v => v == ⟨(41835283002253989567016401978), 11⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-42762798741235107391), 9⟩ ⟨(-97831021901551225234), 13⟩ with
  | .ok v => v == ⟨(43710878114171117760439129473), 25⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-52386641863147013166), 4⟩ ⟨(-50497038837191694961), 12⟩ with
  | .ok v => v == ⟨(-5238664236811740153791694961), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-52386641863147013166), 4⟩ ⟨(-50497038837191694961), 12⟩ with
  | .ok v => v == ⟨(-5238664135817662479408305039), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-52386641863147013166), 4⟩ ⟨(-50497038837191694961), 12⟩ with
  | .ok v => v == ⟨(26453702887133870181529292620), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-52386641863147013166), 4⟩ ⟨(-50497038837191694961), 12⟩ with
  | .ok v => v == ⟨(10374200758988584922083032534), 20⟩
  | .error _ => false
#guard match arithmetic .add ⟨(49761170931051112428), 6⟩ ⟨(9693525132022471844), 4⟩ with
  | .ok v => v == ⟨(1019113684133298296828), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(49761170931051112428), 6⟩ ⟨(9693525132022471844), 4⟩ with
  | .ok v => v == ⟨(-919591342271196071972), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(49761170931051112428), 6⟩ ⟨(9693525132022471844), 4⟩ with
  | .ok v => v == ⟨(48236116101901002276779545585), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(49761170931051112428), 6⟩ ⟨(9693525132022471844), 4⟩ with
  | .ok v => v == ⟨(513344425823641166471844617), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-80054661527847278536), 13⟩ ⟨(82585386209408637989), 8⟩ with
  | .ok v => v == ⟨(8258458566279335951621464), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-80054661527847278536), 13⟩ ⟨(82585386209408637989), 8⟩ with
  | .ok v => v == ⟨(-8258618675602391646178536), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-80054661527847278536), 13⟩ ⟨(82585386209408637989), 8⟩ with
  | .ok v => v == ⟨(-66113451401407548821619712894), 10⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-80054661527847278536), 13⟩ ⟨(82585386209408637989), 8⟩ with
  | .ok v => v == ⟨(-96935626510065235192057), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-52022523544231923279), 5⟩ ⟨(-83522586053418507850), 5⟩ with
  | .ok v => v == ⟨(-135545109597650431129), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-52022523544231923279), 5⟩ ⟨(-83522586053418507850), 5⟩ with
  | .ok v => v == ⟨(31500062509186584571), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-52022523544231923279), 5⟩ ⟨(-83522586053418507850), 5⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-52022523544231923279), 5⟩ ⟨(-83522586053418507850), 5⟩ with
  | .ok v => v == ⟨(6228557567764951404428151164), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-21398486174508078408), 4⟩ ⟨(48447639826343873960), 10⟩ with
  | .ok v => v == ⟨(-21398437726868252064126040), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-21398486174508078408), 4⟩ ⟨(48447639826343873960), 10⟩ with
  | .ok v => v == ⟨(-21398534622147904751873960), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-21398486174508078408), 4⟩ ⟨(48447639826343873960), 10⟩ with
  | .ok v => v == ⟨(-10367061510115663476169848210), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-21398486174508078408), 4⟩ ⟨(48447639826343873960), 10⟩ with
  | .ok v => v == ⟨(-44168273730586240129094113128), 23⟩
  | .error _ => false
#guard match arithmetic .add ⟨(21645447514574194508), 9⟩ ⟨(59241292381096609409), 11⟩ with
  | .ok v => v == ⟨(2223786043838516060209), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(21645447514574194508), 9⟩ ⟨(59241292381096609409), 11⟩ with
  | .ok v => v == ⟨(2105303459076322841391), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(21645447514574194508), 9⟩ ⟨(59241292381096609409), 11⟩ with
  | .ok v => v == ⟨(12823042849305707694579159754), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(21645447514574194508), 9⟩ ⟨(59241292381096609409), 11⟩ with
  | .ok v => v == ⟨(36537770606572843773752739023), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(61581903892257411051), 10⟩ ⟨(-520685439849834312), 9⟩ with
  | .ok v => v == ⟨(56375049493759067931), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(61581903892257411051), 10⟩ ⟨(-520685439849834312), 9⟩ with
  | .ok v => v == ⟨(66788758290755754171), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(61581903892257411051), 10⟩ ⟨(-520685439849834312), 9⟩ with
  | .ok v => v == ⟨(-32064800714930273700020085436), 10⟩
  | .error _ => false
#guard match arithmetic .div ⟨(61581903892257411051), 10⟩ ⟨(-520685439849834312), 9⟩ with
  | .ok v => v == ⟨(-11827083912701233393206678971), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-81079434919927398413), 6⟩ ⟨(39266443112514915680), 5⟩ with
  | .ok v => v == ⟨(311584996205221758387), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-81079434919927398413), 6⟩ ⟨(39266443112514915680), 5⟩ with
  | .ok v => v == ⟨(-473743866045076555213), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-81079434919927398413), 6⟩ ⟨(39266443112514915680), 5⟩ with
  | .ok v => v == ⟨(-31837010188781845373200337432), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-81079434919927398413), 6⟩ ⟨(39266443112514915680), 5⟩ with
  | .ok v => v == ⟨(-2064853052455009263875365937), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-58252139751902604844), 12⟩ ⟨(25668881077262696151), 4⟩ with
  | .ok v => v == ⟨(2566888049474129863197395156), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-58252139751902604844), 12⟩ ⟨(25668881077262696151), 4⟩ with
  | .ok v => v == ⟨(-2566888165978409367002604844), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-58252139751902604844), 12⟩ ⟨(25668881077262696151), 4⟩ with
  | .ok v => v == ⟨(-14952672477876748611274990462), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-58252139751902604844), 12⟩ ⟨(25668881077262696151), 4⟩ with
  | .ok v => v == ⟨(-2269368095031688653), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-35461614503340906969), 4⟩ ⟨(24650531702686618266), 10⟩ with
  | .ok v => v == ⟨(-35461589852809204282381734), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-35461614503340906969), 4⟩ ⟨(24650531702686618266), 10⟩ with
  | .ok v => v == ⟨(-35461639153872609655618266), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-35461614503340906969), 4⟩ ⟨(24650531702686618266), 10⟩ with
  | .ok v => v == ⟨(-8741476525430566044126116160), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-35461614503340906969), 4⟩ ⟨(24650531702686618266), 10⟩ with
  | .ok v => v == ⟨(-14385740206762358691053371089), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(68493527350091787395), 2⟩ ⟨(59386034289225162821), 4⟩ with
  | .ok v => v == ⟨(6908738769298403902321), 4⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(68493527350091787395), 2⟩ ⟨(59386034289225162821), 4⟩ with
  | .ok v => v == ⟨(6789966700719953576679), 4⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(68493527350091787395), 2⟩ ⟨(59386034289225162821), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(68493527350091787395), 2⟩ ⟨(59386034289225162821), 4⟩ with
  | .ok v => v == ⟨(1153360856131776807808362763), 25⟩
  | .error _ => false
#guard match arithmetic .add ⟨(60188650220994693418), 3⟩ ⟨(-28150603987502231158), 8⟩ with
  | .ok v => v == ⟨(6018836871495481839568842), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(60188650220994693418), 3⟩ ⟨(-28150603987502231158), 8⟩ with
  | .ok v => v == ⟨(6018893172703456844031158), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(60188650220994693418), 3⟩ ⟨(-28150603987502231158), 8⟩ with
  | .ok v => v == ⟨(-16943468569135102631375405784), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(60188650220994693418), 3⟩ ⟨(-28150603987502231158), 8⟩ with
  | .ok v => v == ⟨(-21380944525281270571693266142), 23⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-25999069308295310376), 3⟩ ⟨(65444153412600255531), 4⟩ with
  | .ok v => v == ⟨(-194546539670352848229), 4⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-25999069308295310376), 3⟩ ⟨(65444153412600255531), 4⟩ with
  | .ok v => v == ⟨(-325434846495553359291), 4⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-25999069308295310376), 3⟩ ⟨(65444153412600255531), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-25999069308295310376), 3⟩ ⟨(65444153412600255531), 4⟩ with
  | .ok v => v == ⟨(-39727107698041660801698412461), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-93773746247953103647), 13⟩ ⟨(84779906655860673319), 7⟩ with
  | .ok v => v == ⟨(84779812882114425365896353), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-93773746247953103647), 13⟩ ⟨(84779906655860673319), 7⟩ with
  | .ok v => v == ⟨(-84780000429606921272103647), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-93773746247953103647), 13⟩ ⟨(84779906655860673319), 7⟩ with
  | .ok v => v == ⟨(-7950129453671829173428489665), 8⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-93773746247953103647), 13⟩ ⟨(84779906655860673319), 7⟩ with
  | .ok v => v == ⟨(-11060845658700746321622), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-22837098353527441913), 1⟩ ⟨(60416501503164191707), 11⟩ with
  | .ok v => v == ⟨(-22837098347485791762683580829), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-22837098353527441913), 1⟩ ⟨(60416501503164191707), 11⟩ with
  | .ok v => v == ⟨(-22837098359569092063316419171), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-22837098353527441913), 1⟩ ⟨(60416501503164191707), 11⟩ with
  | .ok v => v == ⟨(-13797375870037991818501022554), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-22837098353527441913), 1⟩ ⟨(60416501503164191707), 11⟩ with
  | .ok v => v == ⟨(-37799438539703255100651843768), 19⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-80770579847042933908), 11⟩ ⟨(92188702479220181396), 7⟩ with
  | .ok v => v == ⟨(921806254212354771026092), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-80770579847042933908), 11⟩ ⟨(92188702479220181396), 7⟩ with
  | .ok v => v == ⟨(-921967795372048856893908), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-80770579847042933908), 11⟩ ⟨(92188702479220181396), 7⟩ with
  | .ok v => v == ⟨(-74461349545931385410103241376), 7⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-80770579847042933908), 11⟩ ⟨(92188702479220181396), 7⟩ with
  | .ok v => v == ⟨(-876144014124171533843647), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(53902572769158786305), 7⟩ ⟨(15206697896526778182), 5⟩ with
  | .ok v => v == ⟨(1574572362421836604505), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(53902572769158786305), 7⟩ ⟨(15206697896526778182), 5⟩ with
  | .ok v => v == ⟨(-1466767216883519031895), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(53902572769158786305), 7⟩ ⟨(15206697896526778182), 5⟩ with
  | .ok v => v == ⟨(8196801399461485086826172854), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(53902572769158786305), 7⟩ ⟨(15206697896526778182), 5⟩ with
  | .ok v => v == ⟨(354465993445363154920929961), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(48158624443684888539), 14⟩ ⟨(-30195874398753360215), 13⟩ with
  | .ok v => v == ⟨(-253800119543848713611), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(48158624443684888539), 14⟩ ⟨(-30195874398753360215), 13⟩ with
  | .ok v => v == ⟨(350117368431218490689), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(48158624443684888539), 14⟩ ⟨(-30195874398753360215), 13⟩ with
  | .ok v => v == ⟨(-14541917749182423102792724275), 16⟩
  | .error _ => false
#guard match arithmetic .div ⟨(48158624443684888539), 14⟩ ⟨(-30195874398753360215), 13⟩ with
  | .ok v => v == ⟨(-1594874313216547301240937046), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-36820991254415471732), 14⟩ ⟨(-78932470694363652432), 12⟩ with
  | .ok v => v == ⟨(-7930068060690780714932), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-36820991254415471732), 14⟩ ⟨(-78932470694363652432), 12⟩ with
  | .ok v => v == ⟨(7856426078181949771468), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-36820991254415471732), 14⟩ ⟨(-78932470694363652432), 12⟩ with
  | .ok v => v == ⟨(29063718131265695636045943390), 15⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-36820991254415471732), 14⟩ ⟨(-78932470694363652432), 12⟩ with
  | .ok v => v == ⟨(46648725081710581769038683), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-37296358013748168483), 8⟩ ⟨(-15888505996848815457), 7⟩ with
  | .ok v => v == ⟨(-196181417982236323053), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-37296358013748168483), 8⟩ ⟨(-15888505996848815457), 7⟩ with
  | .ok v => v == ⟨(121588701954739986087), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-37296358013748168483), 8⟩ ⟨(-15888505996848815457), 7⟩ with
  | .ok v => v == ⟨(59258340796205815054803898798), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-37296358013748168483), 8⟩ ⟨(-15888505996848815457), 7⟩ with
  | .ok v => v == ⟨(2347379799028630849385679682), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(21290816877191760985), 3⟩ ⟨(43522345134396756377), 11⟩ with
  | .ok v => v == ⟨(2129081731241521232896756377), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(21290816877191760985), 3⟩ ⟨(43522345134396756377), 11⟩ with
  | .ok v => v == ⟨(2129081644196830964103243623), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(21290816877191760985), 3⟩ ⟨(43522345134396756377), 11⟩ with
  | .ok v => v == ⟨(9266262803223791816579708540), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(21290816877191760985), 3⟩ ⟨(43522345134396756377), 11⟩ with
  | .ok v => v == ⟨(48919277698492207888084465031), 21⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-62171236301224002784), 9⟩ ⟨(40784141930938295279), 9⟩ with
  | .ok v => v == ⟨(-21387094370285707505), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-62171236301224002784), 9⟩ ⟨(40784141930938295279), 9⟩ with
  | .ok v => v == ⟨(-102955378232162298063), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-62171236301224002784), 9⟩ ⟨(40784141930938295279), 9⟩ with
  | .ok v => v == ⟨(-25356005253310229397764030369), 7⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-62171236301224002784), 9⟩ ⟨(40784141930938295279), 9⟩ with
  | .ok v => v == ⟨(-15243973112515516391430029411), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(65480949783552171507), 10⟩ ⟨(-73073240084888176661), 7⟩ with
  | .ok v => v == ⟨(-73007759135104624489493), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(65480949783552171507), 10⟩ ⟨(-73073240084888176661), 7⟩ with
  | .ok v => v == ⟨(73138721034671728832507), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(65480949783552171507), 10⟩ ⟨(-73073240084888176661), 7⟩ with
  | .ok v => v == ⟨(-47849051645200143142084191270), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(65480949783552171507), 10⟩ ⟨(-73073240084888176661), 7⟩ with
  | .ok v => v == ⟨(-8961002647136469373743257), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(37132156127235358484), 2⟩ ⟨(-25193394331695124594), 10⟩ with
  | .ok v => v == ⟨(3713215587530141516704875406), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(37132156127235358484), 2⟩ ⟨(-25193394331695124594), 10⟩ with
  | .ok v => v == ⟨(3713215637916930180095124594), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(37132156127235358484), 2⟩ ⟨(-25193394331695124594), 10⟩ with
  | .ok v => v == ⟨(-9354850516995096700858474451), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(37132156127235358484), 2⟩ ⟨(-25193394331695124594), 10⟩ with
  | .ok v => v == ⟨(-14738846079394868280285329942), 20⟩
  | .error _ => false
#guard match arithmetic .add ⟨(64574789754844797137), 4⟩ ⟨(-84006372196529594507), 9⟩ with
  | .ok v => v == ⟨(6457394969112283184105493), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(64574789754844797137), 4⟩ ⟨(-84006372196529594507), 9⟩ with
  | .ok v => v == ⟨(6457562981856676243294507), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(64574789754844797137), 4⟩ ⟨(-84006372196529594507), 9⟩ with
  | .ok v => v == ⟨(-54246938226581380764497828841), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(64574789754844797137), 4⟩ ⟨(-84006372196529594507), 9⟩ with
  | .ok v => v == ⟨(-76868918471773335673283738702), 24⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-66708490955553648401), 3⟩ ⟨(-70508710854204675331), 8⟩ with
  | .ok v => v == ⟨(-6670919604266219044775331), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-66708490955553648401), 3⟩ ⟨(-70508710854204675331), 8⟩ with
  | .ok v => v == ⟨(-6670778586844510635424669), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-66708490955553648401), 3⟩ ⟨(-70508710854204675331), 8⟩ with
  | .ok v => v == ⟨(47035297003054599430577268937), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-66708490955553648401), 3⟩ ⟨(-70508710854204675331), 8⟩ with
  | .ok v => v == ⟨(9461028310883603847159760007), 23⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-59625653684219789701), 5⟩ ⟨(84501224054514444251), 6⟩ with
  | .ok v => v == ⟨(-511755312787683452759), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-59625653684219789701), 5⟩ ⟨(84501224054514444251), 6⟩ with
  | .ok v => v == ⟨(-680757760896712341261), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-59625653684219789701), 5⟩ ⟨(84501224054514444251), 6⟩ with
  | .ok v => v == ⟨(-50384407213671410884549265081), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-59625653684219789701), 5⟩ ⟨(84501224054514444251), 6⟩ with
  | .ok v => v == ⟨(-70561881619316392485842748468), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(32479817451689760599), 0⟩ ⟨(28250669284170421061), 14⟩ with
  | .ok v => v == ⟨(32479817451690043105692841704), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(32479817451689760599), 0⟩ ⟨(28250669284170421061), 14⟩ with
  | .ok v => v == ⟨(32479817451689478092307158296), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(32479817451689760599), 0⟩ ⟨(28250669284170421061), 14⟩ with
  | .ok v => v == ⟨(9175765812379143186026860264), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(32479817451689760599), 0⟩ ⟨(28250669284170421061), 14⟩ with
  | .ok v => v == ⟨(11497008132791048734209667037), 14⟩
  | .error _ => false
#guard match arithmetic .add ⟨(74504683985051267412), 13⟩ ⟨(64165182684054499222), 2⟩ with
  | .ok v => v == ⟨(64165182684799546061850512674), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(74504683985051267412), 13⟩ ⟨(64165182684054499222), 2⟩ with
  | .ok v => v == ⟨(-64165182683309452382149487326), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(74504683985051267412), 13⟩ ⟨(64165182684054499222), 2⟩ with
  | .ok v => v == ⟨(47806066587185641459092570475), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(74504683985051267412), 13⟩ ⟨(64165182684054499222), 2⟩ with
  | .ok v => v == ⟨(116113881186792299), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-91775392445153266126), 9⟩ ⟨(-55518918357586866620), 2⟩ with
  | .ok v => v == ⟨(-555189275351261111353266126), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-91775392445153266126), 9⟩ ⟨(-55518918357586866620), 2⟩ with
  | .ok v => v == ⟨(555189091800476221046733874), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-91775392445153266126), 9⟩ ⟨(-55518918357586866620), 2⟩ with
  | .ok v => v == ⟨(50952705203979586967647483077), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-91775392445153266126), 9⟩ ⟨(-55518918357586866620), 2⟩ with
  | .ok v => v == ⟨(165304719832697924879), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-36207253422550187583), 7⟩ ⟨(-39301501532497683374), 6⟩ with
  | .ok v => v == ⟨(-429222268747527021323), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-36207253422550187583), 7⟩ ⟨(-39301501532497683374), 6⟩ with
  | .ok v => v == ⟨(356807761902426646157), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-36207253422550187583), 7⟩ ⟨(-39301501532497683374), 6⟩ with
  | .ok v => v == ⟨(14229994258738881886867697022), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-36207253422550187583), 7⟩ ⟨(-39301501532497683374), 6⟩ with
  | .ok v => v == ⟨(921268959472479203772123891), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(16055366445777320767), 8⟩ ⟨(1580571455924553947), 4⟩ with
  | .ok v => v == ⟨(15821769925691316790767), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(16055366445777320767), 8⟩ ⟨(1580571455924553947), 4⟩ with
  | .ok v => v == ⟨(-15789659192799762149233), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(16055366445777320767), 8⟩ ⟨(1580571455924553947), 4⟩ with
  | .ok v => v == ⟨(25376653918604490908673689383), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(16055366445777320767), 8⟩ ⟨(1580571455924553947), 4⟩ with
  | .ok v => v == ⟨(10157950395469939469100469), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-80516169593665074610), 10⟩ ⟨(54084921191602288532), 1⟩ with
  | .ok v => v == ⟨(54084921111086118938334925390), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-80516169593665074610), 10⟩ ⟨(54084921191602288532), 1⟩ with
  | .ok v => v == ⟨(-54084921272118458125665074610), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-80516169593665074610), 10⟩ ⟨(54084921191602288532), 1⟩ with
  | .ok v => v == ⟨(-43547106871230600187178166348), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-80516169593665074610), 10⟩ ⟨(54084921191602288532), 1⟩ with
  | .ok v => v == ⟨(-14886990277461426625), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-59219074817436989796), 11⟩ ⟨(62555533024240347291), 3⟩ with
  | .ok v => v == ⟨(6255553243204959911663010204), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-59219074817436989796), 11⟩ ⟨(62555533024240347291), 3⟩ with
  | .ok v => v == ⟨(-6255553361643109546536989796), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-59219074817436989796), 11⟩ ⟨(62555533024240347291), 3⟩ with
  | .ok v => v == ⟨(-37044807904071395304307263232), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-59219074817436989796), 11⟩ ⟨(62555533024240347291), 3⟩ with
  | .ok v => v == ⟨(-94666405918864961527), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-1525290424984650041), 6⟩ ⟨(56331922253788668609), 3⟩ with
  | .ok v => v == ⟨(56330396963363683958959), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-1525290424984650041), 6⟩ ⟨(56331922253788668609), 3⟩ with
  | .ok v => v == ⟨(-56333447544213653259041), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-1525290424984650041), 6⟩ ⟨(56331922253788668609), 3⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-1525290424984650041), 6⟩ ⟨(56331922253788668609), 3⟩ with
  | .ok v => v == ⟨(-270768396312281864064782), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-41521155512989681462), 0⟩ ⟨(-96659542703880766973), 6⟩ with
  | .ok v => v == ⟨(-41521252172532385342766973), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-41521155512989681462), 0⟩ ⟨(-96659542703880766973), 6⟩ with
  | .ok v => v == ⟨(-41521058853446977581233027), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-41521155512989681462), 0⟩ ⟨(-96659542703880766973), 6⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-41521155512989681462), 0⟩ ⟨(-96659542703880766973), 6⟩ with
  | .ok v => v == ⟨(42956085195013710627515895826), 23⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-31226534044695847382), 9⟩ ⟨(-76643598977127080663), 11⟩ with
  | .ok v => v == ⟨(-3199297003446711818863), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-31226534044695847382), 9⟩ ⟨(-76643598977127080663), 11⟩ with
  | .ok v => v == ⟨(-3046009805492457657537), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-31226534044695847382), 9⟩ ⟨(-76643598977127080663), 11⟩ with
  | .ok v => v == ⟨(23933139527672746093327953481), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-31226534044695847382), 9⟩ ⟨(-76643598977127080663), 11⟩ with
  | .ok v => v == ⟨(40742520525445120652079152764), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-67401764930111498859), 4⟩ ⟨(-92417394296231653346), 13⟩ with
  | .ok v => v == ⟨(-67401765022528893155231653346), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-67401764930111498859), 4⟩ ⟨(-92417394296231653346), 13⟩ with
  | .ok v => v == ⟨(-67401764837694104562768346654), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-67401764930111498859), 4⟩ ⟨(-92417394296231653346), 13⟩ with
  | .ok v => v == ⟨(62290954858080331176681228931), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-67401764930111498859), 4⟩ ⟨(-92417394296231653346), 13⟩ with
  | .ok v => v == ⟨(72931903613365374670071994437), 20⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-46531027119454373712), 13⟩ ⟨(14398651176556258388), 10⟩ with
  | .ok v => v == ⟨(14352120149436804014288), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-46531027119454373712), 13⟩ ⟨(14398651176556258388), 10⟩ with
  | .ok v => v == ⟨(-14445182203675712761712), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-46531027119454373712), 13⟩ ⟨(14398651176556258388), 10⟩ with
  | .ok v => v == ⟨(-66998402837990288466408425867), 13⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-46531027119454373712), 13⟩ ⟨(14398651176556258388), 10⟩ with
  | .ok v => v == ⟨(-32316240284517575106030445), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(58012774110271587029), 8⟩ ⟨(49576195926853094001), 8⟩ with
  | .ok v => v == ⟨(107588970037124681030), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(58012774110271587029), 8⟩ ⟨(49576195926853094001), 8⟩ with
  | .ok v => v == ⟨(8436578183418493028), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(58012774110271587029), 8⟩ ⟨(49576195926853094001), 8⟩ with
  | .ok v => v == ⟨(28760526555510948771955050472), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(58012774110271587029), 8⟩ ⟨(49576195926853094001), 8⟩ with
  | .ok v => v == ⟨(11701739721189216003999017019), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(76703078528577527135), 0⟩ ⟨(-71384331989147895209), 6⟩ with
  | .ok v => v == ⟨(76703007144245537987104791), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(76703078528577527135), 0⟩ ⟨(-71384331989147895209), 6⟩ with
  | .ok v => v == ⟨(76703149912909516282895209), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(76703078528577527135), 0⟩ ⟨(-71384331989147895209), 6⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(76703078528577527135), 0⟩ ⟨(-71384331989147895209), 6⟩ with
  | .ok v => v == ⟨(-10745085986129029973408980079), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(38265782235352652601), 3⟩ ⟨(-41061866711551608097), 9⟩ with
  | .ok v => v == ⟨(38265741173485941049391903), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(38265782235352652601), 3⟩ ⟨(-41061866711551608097), 9⟩ with
  | .ok v => v == ⟨(38265823297219364152608097), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(38265782235352652601), 3⟩ ⟨(-41061866711551608097), 9⟩ with
  | .ok v => v == ⟨(-15712644497613099685016087481), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(38265782235352652601), 3⟩ ⟨(-41061866711551608097), 9⟩ with
  | .ok v => v == ⟨(-9319055683502972526089594296), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-64783775030493086036), 9⟩ ⟨(-69215880941136463325), 11⟩ with
  | .ok v => v == ⟨(-6547593383990445066925), 11⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-64783775030493086036), 9⟩ ⟨(-69215880941136463325), 11⟩ with
  | .ok v => v == ⟨(-6409161622108172140275), 11⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-64783775030493086036), 9⟩ ⟨(-69215880941136463325), 11⟩ with
  | .ok v => v == ⟨(44840660594279786969381587028), 9⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-64783775030493086036), 9⟩ ⟨(-69215880941136463325), 11⟩ with
  | .ok v => v == ⟨(9359669218916307555105000737), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(34007233663628395404), 9⟩ ⟨(-88372158101656947993), 7⟩ with
  | .ok v => v == ⟨(-8803208576502066403896), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(34007233663628395404), 9⟩ ⟨(-88372158101656947993), 7⟩ with
  | .ok v => v == ⟨(8871223043829323194704), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(34007233663628395404), 9⟩ ⟨(-88372158101656947993), 7⟩ with
  | .ok v => v == ⟨(-30052926299221589958580324793), 5⟩
  | .error _ => false
#guard match arithmetic .div ⟨(34007233663628395404), 9⟩ ⟨(-88372158101656947993), 7⟩ with
  | .ok v => v == ⟨(-38481841333453608740551846), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(1586875087061894905), 3⟩ ⟨(41689593067148143335), 12⟩ with
  | .ok v => v == ⟨(1586875128751487972148143335), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(1586875087061894905), 3⟩ ⟨(41689593067148143335), 12⟩ with
  | .ok v => v == ⟨(1586875045372301837851856665), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(1586875087061894905), 3⟩ ⟨(41689593067148143335), 12⟩ with
  | .ok v => v == ⟨(66156176628005680198996388098), 6⟩
  | .error _ => false
#guard match arithmetic .div ⟨(1586875087061894905), 3⟩ ⟨(41689593067148143335), 12⟩ with
  | .ok v => v == ⟨(38064057965400719667076721164), 21⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-9943180092866779702), 8⟩ ⟨(29177370423022725005), 3⟩ with
  | .ok v => v == ⟨(2917727099122179633720298), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-9943180092866779702), 8⟩ ⟨(29177370423022725005), 3⟩ with
  | .ok v => v == ⟨(-2917746985482365367279702), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-9943180092866779702), 8⟩ ⟨(29177370423022725005), 3⟩ with
  | .ok v => v == ⟨(-29011584875239953017371785198), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-9943180092866779702), 8⟩ ⟨(29177370423022725005), 3⟩ with
  | .ok v => v == ⟨(-34078396883294884248536), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(9143117027122278914), 3⟩ ⟨(-54031512062403251021), 5⟩ with
  | .ok v => v == ⟨(860280190649824640379), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(9143117027122278914), 3⟩ ⟨(-54031512062403251021), 5⟩ with
  | .ok v => v == ⟨(968343214774631142421), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(9143117027122278914), 3⟩ ⟨(-54031512062403251021), 5⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(9143117027122278914), 3⟩ ⟨(-54031512062403251021), 5⟩ with
  | .ok v => v == ⟨(-16921823354790646999809646496), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(20419539700181990112), 1⟩ ⟨(74984709818511915482), 8⟩ with
  | .ok v => v == ⟨(204195471986529719631915482), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(20419539700181990112), 1⟩ ⟨(74984709818511915482), 8⟩ with
  | .ok v => v == ⟨(204195322017110082608084518), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(20419539700181990112), 1⟩ ⟨(74984709818511915482), 8⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(20419539700181990112), 1⟩ ⟨(74984709818511915482), 8⟩ with
  | .ok v => v == ⟨(27231604615933178527959095049), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(59066641867956366618), 8⟩ ⟨(-85088822673675307945), 0⟩ with
  | .ok v => v == ⟨(-8508882208300888926543633382), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(59066641867956366618), 8⟩ ⟨(-85088822673675307945), 0⟩ with
  | .ok v => v == ⟨(8508882326434172662456366618), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(59066641867956366618), 8⟩ ⟨(-85088822673675307945), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(59066641867956366618), 8⟩ ⟨(-85088822673675307945), 0⟩ with
  | .ok v => v == ⟨(-69417627382721259885), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-4683411546966952333), 6⟩ ⟨(-8830786936359150089), 5⟩ with
  | .ok v => v == ⟨(-92991280910558453223), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-4683411546966952333), 6⟩ ⟨(-8830786936359150089), 5⟩ with
  | .ok v => v == ⟨(83624457816624548557), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-4683411546966952333), 6⟩ ⟨(-8830786936359150089), 5⟩ with
  | .ok v => v == ⟨(41358209506549360759907930298), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-4683411546966952333), 6⟩ ⟨(-8830786936359150089), 5⟩ with
  | .ok v => v == ⟨(530350418452953707749996884), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(49874223109746532685), 3⟩ ⟨(87694827059075211148), 5⟩ with
  | .ok v => v == ⟨(5075117138033728479648), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(49874223109746532685), 3⟩ ⟨(87694827059075211148), 5⟩ with
  | .ok v => v == ⟨(4899727483915578057352), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(49874223109746532685), 3⟩ ⟨(87694827059075211148), 5⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(49874223109746532685), 3⟩ ⟨(87694827059075211148), 5⟩ with
  | .ok v => v == ⟨(56872480147716118936676071484), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(53390101168084541394), 6⟩ ⟨(87017306670954008782), 4⟩ with
  | .ok v => v == ⟨(8755120768263485419594), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(53390101168084541394), 6⟩ ⟨(87017306670954008782), 4⟩ with
  | .ok v => v == ⟨(-8648340565927316336806), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(53390101168084541394), 6⟩ ⟨(87017306670954008782), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(53390101168084541394), 6⟩ ⟨(87017306670954008782), 4⟩ with
  | .ok v => v == ⟨(61355727050910805177733228), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(69409318841493564559), 14⟩ ⟨(4128008889472798386), 6⟩ with
  | .ok v => v == ⟨(412800958356598680093564559), 14⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(69409318841493564559), 14⟩ ⟨(4128008889472798386), 6⟩ with
  | .ok v => v == ⟨(-412800819537960997106435441), 14⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(69409318841493564559), 14⟩ ⟨(4128008889472798386), 6⟩ with
  | .ok v => v == ⟨(28652228518993723045746491210), 10⟩
  | .error _ => false
#guard match arithmetic .div ⟨(69409318841493564559), 14⟩ ⟨(4128008889472798386), 6⟩ with
  | .ok v => v == ⟨(168142367664227722437), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(95794642184570935797), 12⟩ ⟨(22702792277835987634), 0⟩ with
  | .ok v => v == ⟨(22702792277931782276184570936), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(95794642184570935797), 12⟩ ⟨(22702792277835987634), 0⟩ with
  | .ok v => v == ⟨(-22702792277740192991815429064), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(95794642184570935797), 12⟩ ⟨(22702792277835987634), 0⟩ with
  | .ok v => v == ⟨(21748058628459385860405504877), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(95794642184570935797), 12⟩ ⟨(22702792277835987634), 0⟩ with
  | .ok v => v == ⟨(42195092573741333), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(83350038132374361675), 3⟩ ⟨(53623110270738468503), 5⟩ with
  | .ok v => v == ⟨(8388626923508174636003), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(83350038132374361675), 3⟩ ⟨(53623110270738468503), 5⟩ with
  | .ok v => v == ⟨(8281380702966697698997), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(83350038132374361675), 3⟩ ⟨(53623110270738468503), 5⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(83350038132374361675), 3⟩ ⟨(53623110270738468503), 5⟩ with
  | .ok v => v == ⟨(15543678408721014679486594617), 26⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-33258932342020843809), 3⟩ ⟨(12531018683045081206), 0⟩ with
  | .ok v => v == ⟨(12497759750703060362191), 3⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-33258932342020843809), 3⟩ ⟨(12531018683045081206), 0⟩ with
  | .ok v => v == ⟨(-12564277615387102049809), 3⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-33258932342020843809), 3⟩ ⟨(12531018683045081206), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-33258932342020843809), 3⟩ ⟨(12531018683045081206), 0⟩ with
  | .ok v => v == ⟨(-26541283819982947591189613), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-64736903874010286135), 12⟩ ⟨(-18409666399869802666), 0⟩ with
  | .ok v => v == ⟨(-18409666399934539569874010286), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-64736903874010286135), 12⟩ ⟨(-18409666399869802666), 0⟩ with
  | .ok v => v == ⟨(18409666399805065762125989714), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-64736903874010286135), 12⟩ ⟨(-18409666399869802666), 0⟩ with
  | .ok v => v == ⟨(11917848040809684256180849529), 1⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-64736903874010286135), 12⟩ ⟨(-18409666399869802666), 0⟩ with
  | .ok v => v == ⟨(35164626271809097), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-71018375871717804641), 12⟩ ⟨(52467420431344232846), 9⟩ with
  | .ok v => v == ⟨(52396402055472515041359), 12⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-71018375871717804641), 12⟩ ⟨(52467420431344232846), 9⟩ with
  | .ok v => v == ⟨(-52538438807215950650641), 12⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-71018375871717804641), 12⟩ ⟨(52467420431344232846), 9⟩ with
  | .ok v => v == ⟨(-37261509852126510359322891711), 10⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-71018375871717804641), 12⟩ ⟨(52467420431344232846), 9⟩ with
  | .ok v => v == ⟨(-13535709453192625753206022), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(46926728351385127258), 2⟩ ⟨(-92569955152779835193), 9⟩ with
  | .ok v => v == ⟨(469267190943896119800164807), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(46926728351385127258), 2⟩ ⟨(-92569955152779835193), 9⟩ with
  | .ok v => v == ⟨(469267376083806425359835193), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(46926728351385127258), 2⟩ ⟨(-92569955152779835193), 9⟩ with
  | .ok v => v == ⟨(-43440051389544032416136337257), 0⟩
  | .error _ => false
#guard match arithmetic .div ⟨(46926728351385127258), 2⟩ ⟨(-92569955152779835193), 9⟩ with
  | .ok v => v == ⟨(-50693260328295555155527082289), 22⟩
  | .error _ => false
#guard match arithmetic .add ⟨(69358437402187727912), 5⟩ ⟨(5372629670755302222), 4⟩ with
  | .ok v => v == ⟨(123084734109740750132), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(69358437402187727912), 5⟩ ⟨(5372629670755302222), 4⟩ with
  | .ok v => v == ⟨(15632140694634705692), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(69358437402187727912), 5⟩ ⟨(5372629670755302222), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(69358437402187727912), 5⟩ ⟨(5372629670755302222), 4⟩ with
  | .ok v => v == ⟨(12909588349207230422553666708), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(8906007689128878577), 8⟩ ⟨(74046795145669199050), 10⟩ with
  | .ok v => v == ⟨(964647564058557056750), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(8906007689128878577), 8⟩ ⟨(74046795145669199050), 10⟩ with
  | .ok v => v == ⟨(816553973767218658650), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(8906007689128878577), 8⟩ ⟨(74046795145669199050), 10⟩ with
  | .ok v => v == ⟨(65946132692268080737955584954), 8⟩
  | .error _ => false
#guard match arithmetic .div ⟨(8906007689128878577), 8⟩ ⟨(74046795145669199050), 10⟩ with
  | .ok v => v == ⟨(12027539708651073713571637182), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(20715125999755855057), 5⟩ ⟨(99811832431133282073), 4⟩ with
  | .ok v => v == ⟨(1018833450311088675787), 5⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(20715125999755855057), 5⟩ ⟨(99811832431133282073), 4⟩ with
  | .ok v => v == ⟨(-977403198311576965673), 5⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(20715125999755855057), 5⟩ ⟨(99811832431133282073), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(20715125999755855057), 5⟩ ⟨(99811832431133282073), 4⟩ with
  | .ok v => v == ⟨(207541786331280679716425512), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-88478095478243864813), 13⟩ ⟨(94391628341865236027), 6⟩ with
  | .ok v => v == ⟨(943916194940556882026135187), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-88478095478243864813), 13⟩ ⟨(94391628341865236027), 6⟩ with
  | .ok v => v == ⟨(-943916371896747838513864813), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-88478095478243864813), 13⟩ ⟨(94391628341865236027), 6⟩ with
  | .ok v => v == ⟨(-8351591504778461974600265852), 7⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-88478095478243864813), 13⟩ ⟨(94391628341865236027), 6⟩ with
  | .ok v => v == ⟨(-93735108751166061084), 27⟩
  | .error _ => false
#guard match arithmetic .add ⟨(47945340720152544854), 3⟩ ⟨(-55558256304663294604), 6⟩ with
  | .ok v => v == ⟨(47889782463847881559396), 6⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(47945340720152544854), 3⟩ ⟨(-55558256304663294604), 6⟩ with
  | .ok v => v == ⟨(48000898976457208148604), 6⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(47945340720152544854), 3⟩ ⟨(-55558256304663294604), 6⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(47945340720152544854), 3⟩ ⟨(-55558256304663294604), 6⟩ with
  | .ok v => v == ⟨(-8629741807812683641291922751), 25⟩
  | .error _ => false
#guard match arithmetic .add ⟨(29849471076463701864), 7⟩ ⟨(-66205930569492762242), 0⟩ with
  | .ok v => v == ⟨(-662059275845456545956298136), 7⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(29849471076463701864), 7⟩ ⟨(-66205930569492762242), 0⟩ with
  | .ok v => v == ⟨(662059335544398698883701864), 7⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(29849471076463701864), 7⟩ ⟨(-66205930569492762242), 0⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(29849471076463701864), 7⟩ ⟨(-66205930569492762242), 0⟩ with
  | .ok v => v == ⟨(-450857964229236783416), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(72229393413605850128), 13⟩ ⟨(-28801278193769153287), 8⟩ with
  | .ok v => v == ⟨(-2880055589983501722849872), 13⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(72229393413605850128), 13⟩ ⟨(-28801278193769153287), 8⟩ with
  | .ok v => v == ⟨(2880200048770328934550128), 13⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(72229393413605850128), 13⟩ ⟨(-28801278193769153287), 8⟩ with
  | .ok v => v == ⟨(-20802988534724594761508837489), 10⟩
  | .error _ => false
#guard match arithmetic .div ⟨(72229393413605850128), 13⟩ ⟨(-28801278193769153287), 8⟩ with
  | .ok v => v == ⟨(-250785374620046906109875), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(82071199249426232998), 1⟩ ⟨(94445337142011747236), 4⟩ with
  | .ok v => v == ⟨(82165644586568244745236), 4⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(82071199249426232998), 1⟩ ⟨(94445337142011747236), 4⟩ with
  | .ok v => v == ⟨(81976753912284221250764), 4⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(82071199249426232998), 1⟩ ⟨(94445337142011747236), 4⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(82071199249426232998), 1⟩ ⟨(94445337142011747236), 4⟩ with
  | .ok v => v == ⟨(8689809548355016117630329717), 25⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-97523304634763344400), 14⟩ ⟨(61740706454085224375), 0⟩ with
  | .ok v => v == ⟨(61740706454084249141953652367), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-97523304634763344400), 14⟩ ⟨(61740706454085224375), 0⟩ with
  | .ok v => v == ⟨(-61740706454086199608046347633), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-97523304634763344400), 14⟩ ⟨(61740706454085224375), 0⟩ with
  | .ok v => v == ⟨(-60211577238872526930451370669), 3⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-97523304634763344400), 14⟩ ⟨(61740706454085224375), 0⟩ with
  | .ok v => v == ⟨(-157956249994141), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-84228866734071182376), 12⟩ ⟨(-15830292260239757205), 1⟩ with
  | .ok v => v == ⟨(-15830292261082045872340711824), 10⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-84228866734071182376), 12⟩ ⟨(-15830292260239757205), 1⟩ with
  | .ok v => v == ⟨(15830292259397468537659288176), 10⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-84228866734071182376), 12⟩ ⟨(-15830292260239757205), 1⟩ with
  | .ok v => v == ⟨(13333675771491329943243195947), 2⟩
  | .error _ => false
#guard match arithmetic .div ⟨(-84228866734071182376), 12⟩ ⟨(-15830292260239757205), 1⟩ with
  | .ok v => v == ⟨(532073984165315067), 28⟩
  | .error _ => false
#guard match arithmetic .add ⟨(-14089023633094773888), 1⟩ ⟨(-94227544971164548907), 9⟩ with
  | .ok v => v == ⟨(-1408902457537022359964548907), 9⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(-14089023633094773888), 1⟩ ⟨(-94227544971164548907), 9⟩ with
  | .ok v => v == ⟨(-1408902269081932417635451093), 9⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(-14089023633094773888), 1⟩ ⟨(-94227544971164548907), 9⟩ with
  | .error e => e == .arithmeticOverflow
  | .ok _ => false
#guard match arithmetic .div ⟨(-14089023633094773888), 1⟩ ⟨(-94227544971164548907), 9⟩ with
  | .ok v => v == ⟨(14952128528241171514256774604), 21⟩
  | .error _ => false
#guard match arithmetic .add ⟨(21111932539141343777), 7⟩ ⟨(-87908737920984994411), 8⟩ with
  | .ok v => v == ⟨(123210587470428443359), 8⟩
  | .error _ => false
#guard match arithmetic .sub ⟨(21111932539141343777), 7⟩ ⟨(-87908737920984994411), 8⟩ with
  | .ok v => v == ⟨(299028063312398432181), 8⟩
  | .error _ => false
#guard match arithmetic .mul ⟨(21111932539141343777), 7⟩ ⟨(-87908737920984994411), 8⟩ with
  | .ok v => v == ⟨(-18559233445888916674853791862), 4⟩
  | .error _ => false
#guard match arithmetic .div ⟨(21111932539141343777), 7⟩ ⟨(-87908737920984994411), 8⟩ with
  | .ok v => v == ⟨(-24015738410574590235108519293), 28⟩
  | .error _ => false
