<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NumberSets.aspx.cs" Inherits="Chaow.CodeJam.Blog.NumberSets" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อนี้จะมีจำนวนตั้งแต่ A ถึง B<br />
        โดยจะมีเลขจำนวนเฉพาะอย่างน้อย P<br />
        ถ้าเลขระหว่าง A ถึง B ตัวไหนหารด้วยจำนวนเฉพาะลงตัว จะถือว่าเลขเหล่านั้นอยู่กลุ่มเดียวกัน<br />
        และถ้ามีตัวเลขไหนสามารถหารด้วยจำนวนเฉพาะ 2 ตัวลงตัว
        <br />
        กลุ่มของจำนวนเฉพาะ 2 ตัวนั้นจะรวมกันเป็นกลุ่มเดียวกัน<br />
        อ่านต่อ <a href="https://code.google.com/codejam/contest/32017/dashboard#s=p1">ที่นี่</a><br />
        <br />
        ข้อนี้เขียนเป็น functional ค่อนข้างลำบาก<br />
        เช่น จำนวนเฉพาะอาจจะต้องใช้ <a href="http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes">Sieve</a><br />
        การจัดกลุ่มต้องใช้ <a href="http://en.wikipedia.org/wiki/Disjoint-set_data_structure">Disjoint Set</a><br />
        ซึ่ง data structure ดังกล่าวเป็นแบบ mutable<br />
        <br />
        ข้อดีของ f# อีกอย่างคือ ไม่ใช่ pure functional<br />
        หากจำเป็นต้องใช้ mutable data structure ก็ไม่มีปัญหา<br />
        <br />
        เริ่มจาก Prime<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;prime&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Prime</span>()</pre>
        อันนี้ผมใช้ prime ที่เขียนเอง อ่านเพิ่มได้ <a href="http://www.bloggang.com/viewblog.php?id=chaowman&amp;date=18-07-2008&amp;group=1&amp;gblog=5">ที่นี่</a><br />
        <br />
        เริ่มเลย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;A&nbsp;B&nbsp;P&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">mutable</span>&nbsp;size&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;int&nbsp;(B&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;A&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1L</span>)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;primes&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;prime<span style="color:#b4b4b4;">.</span>FromRange(P,&nbsp;B<span style="color:#b4b4b4;">-</span>A)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;set&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;DisjointSet()</pre>
        size เป็น การประกาศแบบ mutable ซึ่งจะแก้ค่าได้ภายหลัง<br />
        primes คือ จำนวนเฉพาะระหว่าง P ถึง B-A<br />
        set ก็คือ disjoint set เขียนเองก็ได้ครับ logic ตาม <a href="http://en.wikipedia.org/wiki/Disjoint-set_data_structure">wiki</a><pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">for</span>&nbsp;p&nbsp;<span style="color:#569cd6;">in</span>&nbsp;primes&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;start&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;((A&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1L</span>)<span style="color:#b4b4b4;">/</span>p&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1L</span>)<span style="color:#b4b4b4;">*</span>p
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;n&nbsp;<span style="color:#569cd6;">in</span>&nbsp;{start<span style="color:#b4b4b4;">+</span>p<span style="color:#b4b4b4;">..</span>p<span style="color:#b4b4b4;">..</span>B}&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;set<span style="color:#b4b4b4;">.</span>Union(start,&nbsp;n)&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;size&nbsp;<span style="color:#b4b4b4;">&lt;-</span>&nbsp;size&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>
 
size&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;string</pre>
        ทีนี้ก็ loop ตาม prime แต่ละตัว<br />
        ไล่หาตัวที่หารด้วย prime ลงตัว จาก A ถึง B<br />
        แล้วเอาค่าที่ได้ union เข้า disjoint set<br />
        ถ้า union สำเร็จก็หัก size ไป 1<br />
        <br />
        ทำจนจบก็ได้คำตอบครับ</div>
    </form>
</body>
</html>
