<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShoppingPlan.aspx.cs" Inherits="Chaow.CodeJam.Blog.ShoppingPlan" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อถัดมา <a href="https://code.google.com/codejam/contest/32003/dashboard#s=p3">Shopping Plan</a><br />
        ข้อนี้เค้าจะให้ตำแหน่งร้านต่างๆ มา<br />
        ซึ่งแต่ละร้านจะขายของราคาต่างๆ กัน<br />
        การไปร้านต่างๆ ก็ต้องจ่ายค่าเดินทาง<br />
        และของบางอย่างเป็นของสดมาก<br />
        ซื้อเสร็จต้องรีบเอากลับบ้าน ห้ามแวะที่อื่น<br />
        โจทย์ให้หาราคาที่ถูกที่สุดที่สามารถซื้อของทุกอย่างได้<br />
        อ่านเพิ่มเติม <a href="https://code.google.com/codejam/contest/32003/dashboard#s=p3">ที่นี่</a><br />
        <br />
        *** คำเตือน: บทนี้อาจจะเข้าใจยากหน่อย แต่ถ้าลองทำไปด้วย น่าจะเข้าใจมากขึ้น ***<br />
        <br />
        ข้อนี้ก็ยังเป็นแบบ <a href="http://en.wikipedia.org/wiki/Dynamic_programming">Dynamic Programming</a> สูตรคือ<br />
        <br />
        findMinCost(ของที่ยังไม่รู้ราคา, สถานที่) = min { ค่าของ + ค่าเดินทาง + findMinCost(ของที่ยังไม่รู้ราคา - ของที่ซื้อไป, ร้านที่ซื้อ) }<br />
        <br />
        วิธีคิด ให้คิดถอยหลัง <br />
        เริ่มจากเราอยู่ที่บ้าน และมีของครบทุกอย่าง (แต่ไม่รู้ราคาสักชิ้น)<br />
        ทีนี้ตัวเลือกเราจะมีเพียบ คือ ก่อนเราอยู่บ้าน เราไปร้านไหนมาก็ไม่รู้ และซื้อของอะไรมาก็ไม่รู้<br />
        สมมติ ร้านมี Top, BigC, Lotus และของมี Lay, Pocky, Pepsi<br />
        เนื่องจากเราไม่รู้อะไรเลย เราจึงต้องลองทุกๆ แบบ เช่น เราอาจจะมาจาก Top และซื้อ Lay<br />
        พอเราย้อนไปที่ Top เราก็จะรู้ราคาของ Lay รู้ค่าเดินทาง และจาก Top เราก็ findMinCost อีกครั้ง<br />
        โดยคราวนี้ของที่ยังไม่รู้ราคามีแค่ Pocky และ Pepsi พอเรา findMinCost ย้อนไปเรื่อยๆ จนรู้ราคาของจนหมด<br />
        เราก็กลับมาลองแบบอื่น เช่น ไป BigC และซื้อ Lay แทน<br />
        พอเราย้อนไปย้อนมาจนครบทุกรูปแบบ เราก็จะรู้ว่าแบบไหนถูกที่สุด<br />
        <br />
        เริ่มแรกมารู้จัก class ของร้านขายของก่อน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">type</span>&nbsp;Store&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;{&nbsp;id<span style="color:#b4b4b4;">:</span>int;&nbsp;position<span style="color:#b4b4b4;">:</span>float<span style="color:#b4b4b4;">*</span>float;&nbsp;items<span style="color:#b4b4b4;">:</span>Map<span style="color:#b4b4b4;">&lt;</span>int,float<span style="color:#b4b4b4;">&gt;</span>;&nbsp;costToHome<span style="color:#b4b4b4;">:</span>float&nbsp;}
<span style="color:#569cd6;">let</span>&nbsp;homeStore&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;{&nbsp;id<span style="color:#b4b4b4;">=</span><span style="color:#b5cea8;">0</span>;&nbsp;position<span style="color:#b4b4b4;">=</span><span style="color:#b5cea8;">0.0</span>,<span style="color:#b5cea8;">0.0</span>;&nbsp;items<span style="color:#b4b4b4;">=</span>Map<span style="color:#b4b4b4;">.</span>empty;&nbsp;costToHome<span style="color:#b4b4b4;">=</span><span style="color:#b5cea8;">0.0</span>&nbsp;}</pre>
        แบบนี้ f# เค้าเรียกว่า <a href="http://msdn.microsoft.com/en-us/library/dd233184.aspx">record</a><br />
        บรรทัดถัดมา homeStore คือบ้านเราเอง<br />
        id คือ id ของร้าน เลข 0 คือบ้านเรา ร้านต่างๆ จะเริ่มที่ 1,2,3,... ไปเรื่อยๆ<br />
        position คือ ตำแหน่ง บ้านเราจะเป็นตำแหน่ง 0,0<br />
        items คือ ของต่างๆ ที่ขาย เป็น <a href="http://msdn.microsoft.com/en-us/library/ee353686.aspx">map</a> (คล้ายๆ dictionary) บ้านเราจะไม่มีของขาย (Map.empty)<br />
        key ของ map คือ itemId ซึ่งเป็น flag ซึ่ง itemId จะเริ่มที่ 1,2,4,8,... ไปเรื่อยๆ ทีละ 2 เท่า<br />
        ส่วน value ของ map คือ ราคาของ<br />
        สุดท้าย costToHome ค่าเดินทางกลับมาบ้าน<br />
        <br />
        ถัดมามารู้จัก function หาระยะทาง<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;(<span style="color:#b4b4b4;">&lt;-&gt;</span>)&nbsp;(x1,&nbsp;y1)&nbsp;(x2,&nbsp;y2)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;deltaX&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;x1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;x2
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;deltaY&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;y1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;y2
&nbsp;&nbsp;&nbsp;&nbsp;sqrt&nbsp;(deltaX<span style="color:#b4b4b4;">*</span>deltaX&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;deltaY<span style="color:#b4b4b4;">*</span>deltaY)</pre>
        การประกาศแบบนี้เรียกว่า <a href="http://msdn.microsoft.com/en-us/library/dd233204.aspx">operator overload</a><br />
        วิธีใช้ เช่น store1.position &lt;-&gt; store2.position<br />
        ซึ่งบางครั้งการใช้ operator อ่านง่ายกว่า การใช้ function<br />
        วิธีการหาตำแหน่ง ก็ใช้ <a href="http://en.wikipedia.org/wiki/Pythagorean_theorem">ทฤษฎีบทพีทาโกรัส</a><br />
        <br />
        เรามาเริ่มคำนวนกันเลย!<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;gas&nbsp;allItems&nbsp;freshMask&nbsp;stores&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;</pre>
        gas คือ ค่า gas<br />
        allItems เป็น sequence เก็บ itemId ของสินค้าทุกตัว เช่น [1;2;4;8;16;32;...] (อย่าลืมว่า itemId เป็น flag ต้องเพิ่มทีละ 2 เท่า)<br />
        freshMask คือ mask ของสินค้าที่เป็นของสด เช่น itemId 2,4,16 เป็นของสด freshMask จะได้ 22 (ง่ายๆ ก็เอา id มาบวกกัน)<br />
        ส่วน stores เป็น array ที่เก็บ type Store ที่ประกาศไว้ด้านบน โดย array ที่ 0 คือบ้านเราเอง array ที่ 1 คือ ร้าน id=1 ไปเรื่อยๆ<br />
        <br />
        วิธีการ build input ผมว่าไม่ยากมาก ลองหัดทำเองแล้วส่งค่าเข้ามานะครับ<br />
        <br />
        ก่อนจะเริ่มทำ อาจต้องคำนวน search space ก่อน<br />
        ร้านมีได้ 50 ร้าน และของมีได้ 15 ชนิด<br />
        หมายความว่า ต่อ 1 รอบ เราต้องหาค่า min ของ 750 ทางเลือก (50 x 15)<br />
        แล้วจำนวนครั้งที่เรา call findMinCost คือ จำนวนรูปแบบของ ของที่ยังไม่รู้ราคา และจำนวนร้าน<br />
        ของที่ยังไม่รู้ราคามี 2 สถานะ รู้แล้ว และยังไม่รู้ ของมี 15 ชนิด ดังนั้นมี input 32,768 แบบ (2<sup>15</sup>)<br />
        สถานที่มี 50 แห่ง รวมบ้านของเราเป็นจุดเริ่มต้นอีก เป็น 51 แห่ง<br />
        เอาตัวเลขทุกตัวมาคูณกันได้กว่า 1 พันล้านแบบ (750 x 32,768 x 51)<br />
        นี่ยังไม่รวมที่ต้องจัดการกับของสดอีก<br />
        <br />
        วิธีการลดจำนวนการคำนวนที่ดีคือ การลดตัวเลือก<br />
        1. เนื่องจากบางร้านขายของราคาแพงมาก เราสามารถตัดของชิ้นนั้นออกจากตัวเลือกได้เลย<br />
        2. ถ้าเราอยู่ร้าน A ซึ่งขายของชิ้นนึง 20 บาท เราสามารถตัดตัวเลือกที่จะซื้อของชิ้นเดียวกัน แต่แพงกว่า 20 บาทได้เลย<br />
        3. ถ้าอยู่บ้าน แปลว่าจะต้องซื้อของสดแล้วกลับเข้ามาเสมอ<br />
        4. ถ้าอยู่ร้าน แล้วไม่ได้กลับบ้านแปลว่าซื้อของแห้งเสมอ<br />
        <br />
        เริ่มข้อ 1 ตัดของราคาแพงออกไป<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;storeMap&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;storeMapX&nbsp;itemId&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;itemPrices&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;store&nbsp;<span style="color:#569cd6;">in</span>&nbsp;stores&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;item&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;store<span style="color:#b4b4b4;">.</span>items<span style="color:#b4b4b4;">.</span>TryFind(itemId)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;item<span style="color:#b4b4b4;">.</span>IsSome&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;store,item<span style="color:#b4b4b4;">.</span>Value
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache
</pre>storeMap มี input คือ itemId เพื่อต้องการหาว่า itemId นี้ มีร้านไหนขายบ้าง (และต้องขายไม่แพง)<br />
        itemPrices ก็แค่ loop ทุกร้าน เพื่อหาว่าร้านไหนขาย itemId นี้บ้าง และราคาเท่าไหร่
        <br />
        function ไม่จบ มีต่อ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;filterFn&nbsp;(store1,price1)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;forallFn&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;itemId&nbsp;<span style="color:#b4b4b4;">&amp;&amp;&amp;</span>&nbsp;freshMask&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">fun</span>&nbsp;(store2,price2)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;price1&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;price2&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;(store1<span style="color:#b4b4b4;">.</span>position&nbsp;<span style="color:#b4b4b4;">&lt;-&gt;</span>&nbsp;store2<span style="color:#b4b4b4;">.</span>position)<span style="color:#b4b4b4;">*</span>gas&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;store2<span style="color:#b4b4b4;">.</span>costToHome&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;store1<span style="color:#b4b4b4;">.</span>costToHome
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">fun</span>&nbsp;(store2,price2)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;price1&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;price2&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;(store1<span style="color:#b4b4b4;">.</span>position&nbsp;<span style="color:#b4b4b4;">&lt;-&gt;</span>&nbsp;store2<span style="color:#b4b4b4;">.</span>position)<span style="color:#b4b4b4;">*</span>gas<span style="color:#b4b4b4;">*</span><span style="color:#b5cea8;">2.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;itemPrices&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>forall&nbsp;forallFn
</pre>สมมติอยู่ร้านแรก เพื่อเปรียบเทียบราคา เราต้องเดินทางไปร้าน 2 เพื่อซื้อของ และกลับมาร้านแรกใหม่<br />
        ถ้าค่าใช้จ่ายทั้งหมด ยังถูกกว่าการซื้อของที่ร้านแรก <br />
        แปลว่าของร้านแรกแพงมากถึงขนาดเดินไปซื้อที่ร้าน 2 แล้วยังคุ้มกว่า เราสามารถตัดของชิ้นนั้นออกจากร้านแรกได้เลย<br />
        function ไม่จบ มาต่อส่วนสุดท้าย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;itemPrices&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;filterFn
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(store,price)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;store<span style="color:#b4b4b4;">.</span>id,(store,price))
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>ofSeq
&nbsp;&nbsp;&nbsp;&nbsp;memoize&nbsp;storeMapX</pre>
        เมื่อเอา itemPrices ผ่าน filterFn จะเหลือแค่ของที่ไม่แพงมากเท่านั้น<br />
        บรรทัดสุดท้ายมีการเรียก memoize (ดูวิธีการประกาศ<a href="http://www.bloggang.com/viewblog.php?id=chaowman&amp;date=25-05-2014&amp;group=12&amp;gblog=3">บทที่แล้ว</a>) เพื่อเมื่อเรียกซ้ำจะได้ไม่ต้องคำนวนใหม่<br />
        <br />
        ถัดมาข้อ 2 หาร้านที่จะซื้อของชิ้นถัดไป โดยร้านที่จะซื้อต้องขายของถูกว่าร้านที่เรายืนอยู่<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;findStores&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;findStoresX&nbsp;(storeId,&nbsp;itemId)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;store1&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>get&nbsp;stores&nbsp;storeId
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;map&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;storeMap&nbsp;itemId
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;item1&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>tryFind&nbsp;storeId&nbsp;map
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;kvp&nbsp;<span style="color:#569cd6;">in</span>&nbsp;map&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;store2,price2&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;kvp<span style="color:#b4b4b4;">.</span>Value
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;storeId&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;store2<span style="color:#b4b4b4;">.</span>id&nbsp;<span style="color:#b4b4b4;">||</span>&nbsp;item1<span style="color:#b4b4b4;">.</span>IsNone&nbsp;<span style="color:#b4b4b4;">||</span>&nbsp;snd&nbsp;item1<span style="color:#b4b4b4;">.</span>Value&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;price2&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;travel&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(store1<span style="color:#b4b4b4;">.</span>position&nbsp;<span style="color:#b4b4b4;">&lt;-&gt;</span>&nbsp;store2<span style="color:#b4b4b4;">.</span>position)<span style="color:#b4b4b4;">*</span>gas
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;store2<span style="color:#b4b4b4;">.</span>id,&nbsp;itemId,&nbsp;price2&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;travel
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;cached&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;memoize&nbsp;findStoresX
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">fun</span>&nbsp;storeId&nbsp;itemId&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;cached&nbsp;(storeId,&nbsp;itemId)</pre>
        findStores มี input 2 ตัว คือ storeId และ itemId<br />
        storeId คือ ปัจจุบันเราอยู่ที่ร้านไหน<br />
        itemId คือ ปัจจุบันเราอยากรู้ราคาของของชิ้นไหน<br />
        เป้าหมายของ findStores คือ บอกว่าเราควรไปซื้อ itemId นี้ที่ร้านไหนบ้าง<br />
        <br />
        ใน code จะมี for in อยู่ คือเราก็ไปทุกๆ ร้าน (ที่ขายของไม่แพงมากจาก function storeMap ด้านบน)<br />
        และก็มีการเช็คนิดหน่อยว่า ถ้าร้านที่เรายืนอยู่ขายของชิ้นเดียวกันถูกกว่า เราจะไม่ไปร้านอื่น<br />
        แล้วก็คืนค่า storeId ร้านใหม่ (store2.id), itemId, และราคาของบวกค่าเดินทาง<br />
        function นี้ก็มีการเรียก memoize เพราะ function นี้มีการเรียก input เดิมๆ ซ้ำหลายครั้ง<br />
        <br />
        ถัดมาข้อ 3 และข้อ 4 เรามีการแยกของแห้งและของสด<br />
        ถ้าอยู่บ้าน เราก็เลือกที่จะซื้อของสด และกลับบ้าน<br />
        ถ้าอยู่ร้าน ยังไงก็ต้องซื้อของแห้ง<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;isFresh&nbsp;itemId&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;itemId&nbsp;<span style="color:#b4b4b4;">&amp;&amp;&amp;</span>&nbsp;freshMask&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;<span style="color:#b5cea8;">0</span>
<span style="color:#569cd6;">let</span>&nbsp;dryItems&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;allItems&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;(not&nbsp;<span style="color:#b4b4b4;">&lt;&lt;</span>&nbsp;isFresh)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache
<span style="color:#569cd6;">let</span>&nbsp;freshItems&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;allItems&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;isFresh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache</pre>
        ไม่มีอะไรมาก dryItems คือ รายการของแห้ง freshItems คือ รายการของสด<br />
        <br />
        และ function สุดท้าย ยาวนิดนึงแต่เป็น logic ทั้งหมดของ program<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;findMinCost&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;findMinCostX&nbsp;(mask,&nbsp;id,&nbsp;home)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;filterFn&nbsp;itemId&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;mask&nbsp;<span style="color:#b4b4b4;">&amp;&amp;&amp;</span>&nbsp;itemId&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;<span style="color:#b5cea8;">0</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;validFreshItems&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;filterFn&nbsp;freshItems
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;validDryItems&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;filterFn&nbsp;dryItems
 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;mapFn&nbsp;(storeId,&nbsp;itemId,&nbsp;itemCost)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newHome&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;id&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#b4b4b4;">||</span>&nbsp;(home&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;id&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;storeId)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;itemCost&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;findMinCost&nbsp;(mask&nbsp;<span style="color:#b4b4b4;">^^^</span>&nbsp;itemId,&nbsp;storeId,&nbsp;newHome)
</pre>findMinCost เป็น logic ในการหาราคาที่ถูกที่สุด<br />
        ถ้ายังจำได้ findMinCost ผมได้ define procedure คร่าวๆ ไว้ว่า<br />
        <br />
        findMinCost(ของที่ยังไม่รู้ราคา, สถานที่) = min { ค่าของ + ค่าเดินทาง + findMinCost(ของที่ยังไม่รู้ราคา - ของที่ซื้อไป, ร้านที่ซื้อ) }<br />
        <br />
        ดังนั้น mask คือ ของที่ยังไม่รู้ราคา เป็น flag<br />
        id คือ storeId สถานที่ๆ เรายืนอยู่<br />
        parameter อีกตัวคือ home คือบอกว่าเราจะกลับไปบ้านหรือเปล่า (ถ้าใช่จะได้ซื้อของสดติดมือกลับไปได้)<br />
        <br />
        validFreshItems กับ validDryItems ก็คือ freshItems กับ dryItems ที่เรายังไม่รู้ราคา<br />
        mapFn คือ ค่าของ + ค่าเดินทาง + ผลลัพธ์จาก findMinCost ที่เป็น subproblem เพื่อเอามาหา mininum cost<br />
        function ไม่จบ มีต่อ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;mask,&nbsp;id,&nbsp;home&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">0</span>,&nbsp;id,&nbsp;_&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;stores<span style="color:#4ec9b0;">.</span>[id]<span style="color:#b4b4b4;">.</span>costToHome
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;mask,&nbsp;<span style="color:#b5cea8;">0</span>,&nbsp;_&nbsp;<span style="color:#569cd6;">-&gt;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;items&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">if</span>&nbsp;mask&nbsp;<span style="color:#b4b4b4;">&amp;&amp;&amp;</span>&nbsp;freshMask&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;validFreshItems&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>truncate&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;validDryItems
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;items&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>collect&nbsp;(findStores&nbsp;id)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;mapFn
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>min
</pre>เริ่มทำการ match<br />
        แบบแรกคือ mask=0 ซึ่งหมายความว่า เรารู้ราคาของครบแล้ว
        <br />
        ซึ่งค่าใช้จ่ายมีแค่ค่าเดินทางจากบ้าน มาร้านที่เราอยู่เท่านั้น<br />
        <br />
        แบบถัดมาคือ id=0 หมายความว่าเราอยู่บ้าน ถ้าเราอยู่บ้าน<br />
        และมีของสดที่ยังไม่รู้ราคา เราก็สนใจแค่ของสดเท่านั้น<br />
        ของสดต่างจากของแห้ง ตรงที่เราไม่สนใจลำดับการซื้อก่อนหลัง<br />
        เพราะยังไงซื้อเสร็จ ต้องกลับบ้านอยู่ดี<br />
        ดังนั้น validFreshItems อาจจะมีหลายชิ้น แต่เราสนใจแค่อันแรกเท่านั้น (Seq.truncate 1) <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;mask,&nbsp;id,&nbsp;home&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;freshItemStores&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;mask&nbsp;<span style="color:#b4b4b4;">&amp;&amp;&amp;</span>&nbsp;freshMask&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;costToHome&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;stores<span style="color:#4ec9b0;">.</span>[id]<span style="color:#b4b4b4;">.</span>costToHome
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;<span style="color:#b5cea8;">0</span>,&nbsp;<span style="color:#b5cea8;">0</span>,&nbsp;costToHome
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;home&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;itemId&nbsp;<span style="color:#569cd6;">in</span>&nbsp;validFreshItems&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;result&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>tryFind&nbsp;id&nbsp;(storeMap&nbsp;itemId)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;result<span style="color:#b4b4b4;">.</span>IsSome&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;id,&nbsp;itemId,&nbsp;snd&nbsp;result<span style="color:#b4b4b4;">.</span>Value
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;validDryItems&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>collect&nbsp;(findStores&nbsp;id)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>append&nbsp;freshItemStores
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;mapFn
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>min
&nbsp;&nbsp;&nbsp;&nbsp;memoize&nbsp;findMinCostX</pre>
        แบบสุดท้าย คืออยู่ที่ร้าน<br />
        ถ้ามีของสดที่ยังไม่รู้ราคา เราอาจจะต้องกลับไปเริ่มที่บ้าน<br />
        หรือซื้อของสดในร้านเดียวกัน<br />
        มิเช่นนั้น เราจะซื้อแต่ของแห้งเท่านั้น<br />
        <br />
        และเราก็ทำการ memoize อีกครั้ง<br />
        <br />
        วิธีการหาคือสั่งอย่างนี้ครับ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;minCost&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;findMinCost&nbsp;(<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sum&nbsp;allItems,&nbsp;<span style="color:#b5cea8;">0</span>,&nbsp;<span style="color:#569cd6;">false</span>)
sprintf&nbsp;<span style="color:#d69d85;">&quot;%.7f&quot;</span>&nbsp;minCost</pre>
        จบ</div>
    </form>
</body>
</html>
