<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlienNumbers.aspx.cs" Inherits="Chaow.CodeJam.Blog.AlienNumbers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ไม่ได้เขียน blog มานานมาก<br />
        แต่ว่าตอนนี้มีองค์ประกอบดีๆ 3 อย่างคือ<br />
        1. เพิ่งพลาดไม่ได้ join <a href="https://code.google.com/codejam">codejam</a> เลยต้องฝึกฝีมือเผื่อปีหน้า<br />
        2. กำลังหัดเขียน <a href="http://fsharp.org/">f#</a><br />
        3. ช่วงนี้งานค่อนข้างโอเค ไม่ยุ่งมาก<br />
        <br />
        เลยตั้งเป้าว่า solve codejam ไปเรื่อย ๆ ด้วย f# และเขียน blog ไปด้วย<br />
        <br />
        เริ่มที่ข้อแรก <a href="https://code.google.com/codejam/contest/32003/dashboard">Alien Numbers</a><br />
        โจทย์คือ จะมีตัวเลขภาษาต่างดาวมา 2 ชุด ให้แปลจากตัวเลขภาษานึงไปอีกภาษานึง<br />
        <br />
        สมมติมนุษย์ใช้เลข<a href="http://en.wikipedia.org/wiki/Decimal">อารบิก</a> 0123456789 มนุษย์ต่างดาวใช้เลข <a href="http://en.wikipedia.org/wiki/Hexadecimal">hex</a> 0123456789abcdef<br />
        ดังนั้นเลข 10 จะเท่ากับ a<br />
        <br />
        มนุษย์ต่างดาวไม่ได้ใช้ภาษาเหมือนเรา 0-9 ของเขาอาจจะเป็น )!@#$%^&amp;*(<br />
        แต่หลักการนับเหมือนเลขของมนุษย์ทุกอย่าง<br />
        อ่านรายละเอียดเพิ่ม <a href="https://code.google.com/codejam/contest/32003/dashboard">ที่นี่</a>ครับ<br />
        <br />
        โจทย์ข้อนี้ถือว่าง่ายมาก ถ้ารู้จัก<a href="http://en.wikipedia.org/wiki/Radix">เลขฐาน</a>ก็สบายเลย<br />
        วิธีคิดคือให้แปลจากภาษาแรกเป็น int ก่อน แล้วจาก int ค่อยแปลเป็นภาษาที่สอง<br />
        <br />
        เริ่มจาก function หลัก<br />
        <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;value&nbsp;txt1&nbsp;txt2&nbsp;<span style="color:#b4b4b4;">=</span></pre>
        function ชื่อ solve<br />
        value คือ เลขที่ต้องแปล เช่น foo<br />
        txt1 คือ ชุดตัวเลขของเลขที่ต้องแปล เช่น of8<br />
        txt2 คือ ชุดตัวเลขอีกภาษานึง ที่เราต้องการแปลเป็นภาษานี้ เช่น 0123456789<br />
        value type เป็น string ส่วน txt1 กับ txt2 เป็น char[]<br />
        <br />
        function การแปลจาก txt1 เป็น int คือ
        
        <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;txtToNum&nbsp;txt&nbsp;v&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;baseN&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;Array<span style="color:#b4b4b4;">.</span>length&nbsp;txt
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;foldFn&nbsp;a&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;a&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;baseN&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;Array<span style="color:#b4b4b4;">.</span>IndexOf(txt,&nbsp;b)
&nbsp;&nbsp;&nbsp;&nbsp;Seq<span style="color:#b4b4b4;">.</span>fold&nbsp;foldFn&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;v</pre>
        baseN คือ จำนวนเลขฐาน เช่น of8 เป็นเลขฐาน 3<br />
        foldFn คือ สูตรการคำนวนเลขฐานอื่นๆ เป็น int<br />
        โดยเอาเลขก่อนหน้า (a) x เลขฐาน (baseN) + ค่าของตัวอักษรนั้น<br />
        <br />
        เช่นเลข foo จาก of8<br />
        โดยถ้านับตามตำแหน่ง f เท่ากับ 1 ส่วน o เท่ากับ 0<br />
        f = 1<br />
        fo = 1 * 3 + 0 = 3<br />
        foo = 3 * 3 + 0 = 9<br />
        ดังนั้น foo = 9<br />
        <br />
        function การแปลจาก int เป็น txt2 คือ
        
        <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;numToTxt&nbsp;txt&nbsp;v&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;baseN&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;Array<span style="color:#b4b4b4;">.</span>length&nbsp;txt
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;unfoldFn&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">function</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;None
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;n&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">match</span>&nbsp;Math<span style="color:#b4b4b4;">.</span>DivRem(n,&nbsp;baseN)&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">0</span>,&nbsp;r&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Some(r,&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;d,&nbsp;r&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Some(r,&nbsp;d)
&nbsp;&nbsp;&nbsp;&nbsp;v&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>unfold&nbsp;unfoldFn
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Enumerable<span style="color:#b4b4b4;">.</span>Reverse
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>map&nbsp;(Array<span style="color:#b4b4b4;">.</span>get&nbsp;txt)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>map&nbsp;string
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;String<span style="color:#b4b4b4;">.</span>Concat</pre>
        unfoldFn คือ function แปลเลข int เป็นเลขฐานใด ๆ<br />
        สมมติเป็นเลข 454 และต้องการแปลเป็นเลขฐาน 6<br />
        <br />
        454 / 6 ได้ 75 เศษ 4<br />
        75 / 6 ได้ 12 เศษ 3<br />
        12 / 6 ได้ 2 เศษ 0<br />
        2 / 6 ได้ 0 เศษ 2<br />
        <br />
        เราจะได้ 4,3,0,2 ผลลัพธ์ที่ได้ต้องอ่านย้อนหลัง<br />
        เราเลยต้อง call Enumerable.Reverse เป็น 2,0,3,4<br />
        Seq.map (Array.get txt) คือการ map กับอีกชุดอักษร<br />
        เช่น 2,0,3,4 map กับ A?JM!. ก็จะกลายเป็น J,A,M,!<br />
        <br />
        แล้ว Seq.map string กับ String.Concat คือ แปลงเป็น string<br />
        จาก J,A,M,! เป็น JAM!<br />
        <br />
        เวลาเรียก function ก็ง่าย
        
        <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;">value&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;txtToNum&nbsp;txt1
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;numToTxt&nbsp;txt2</pre>
        โยน value เข้าไป txtToNum และเอาผลลัพธ์ไป numToTxt<br />
        <br />
        จบ<br />
    
    </div>
    </form>
</body>
</html>
