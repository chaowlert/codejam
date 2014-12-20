<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FlySwatter.aspx.cs" Inherits="Chaow.CodeJam.Blog.FlySwatter" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อนี้สนุกมาก<br />
        <br />
        สมมติว่าเราเป็นนักเทนนิส ซึ่งจะใช้ไม้เทนนิสของเราตบแมลงวัน<br />
        โจทย์จะให้ขนาดของแมลงวัน (f)<br />
        ขนาดของไม้ (R)<br />
        ความหนาของไม้ (t)<br />
        ความหนาของเส้นเอ็น (r)<br />
        และความห่างของเส้นเอ็น (g)<br />
        <br />
        <img alt="" src="https://code.google.com/codejam/contest/images/?image=test2.png&p=24479&c=32013" /><br />
        <br />
        โจทย์ให้หาว่า โอกาสที่ไม้เทนนิสจะตบโดนแมลงวันเป็นเท่าไหร่?<br />
        อ่านต่อ <a href="https://code.google.com/codejam/contest/32013/dashboard#s=p2">ที่นี่</a><br />
        <br />
        โจทย์ข้อนี้ ใครมานั่งหาสูตรคำนวนพื้นที่ก็อ้วกครับ มานั่งคำนวนเส้นตัดวงกลมทีละช่อง โหดแท้<br />
        เนื่องจากโจทย์ไม่ได้ให้คำนวนละเอียดมาก ทศนิยมหกหลัก เราสามารถใช้วิธี <a href="http://en.wikipedia.org/wiki/Divide_and_conquer_algorithms">divide and conquer</a> ได้<br />
        หลักการคือ แบ่งไม้เป็นสี่ส่วน แล้วก็พิจารณาดูว่าในส่วนนึง มีทั้งเส้นเอ็นและขอบเทนนิสหรือเปล่า<br />
        ถ้ามี เราก็แบ่งเป็นสี่ส่วนอีก แบ่งเฉพาะช่องที่มีขอบเทนนิสไปเรื่อยๆ จนทศนิยมไม่เกินหกหลักเราก็หยุด<br />
        <br />
        เริ่มเลยละกัน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;f&nbsp;R&nbsp;t&nbsp;r&nbsp;g&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;Rin&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;R&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;t&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;f
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;start&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b4b4b4;">-</span>(r&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;f)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;r&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(r&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;f)<span style="color:#b4b4b4;">*</span><span style="color:#b5cea8;">2.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;g&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;g&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;f<span style="color:#b4b4b4;">*</span><span style="color:#b5cea8;">2.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;rg&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;r&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;g</pre>
        วิธีที่จะทำให้คิดง่ายขึ้นคือ เอาขนาดของแมลงวันมาขยายขนาดไม้ แล้วแมลงวันจะเหลือแค่จุดเดียว<br />
        <br />
        Rin คือขนาดไม้ด้านใน (หักขนาดของแมลงวันแล้ว)<br />
        start สมมติว่า 0 คือกลางไม้ start คือจุดซ้ายล่างของเส้นเอ็นกลางไม้<br />
        r คือ ขนาดของเส้นเอ็น (รวมขนาดของแมลงวันแล้ว)<br />
        g คือ ช่องว่างระหว่างเส้นเอ็น (หักขนาดของแมลงวันแล้ว)<br />
        rg คือ ความห่างระหว่างจุดศูนย์กลางของเส้นเอ็น<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;calculateGap&nbsp;p&nbsp;len&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#57a64a;">//calculate&nbsp;head</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;num&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;floor&nbsp;((p&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;start)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;rg)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;headBlock&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;start&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;rg<span style="color:#b4b4b4;">*</span>num
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;headTouch&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">if</span>&nbsp;p&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;headBlock&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;r
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#b5cea8;">0.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;min&nbsp;(headBlock&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;r&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;p)&nbsp;len
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;head&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;min&nbsp;(headBlock&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;rg&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;p)&nbsp;len
 
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#57a64a;">//calculate&nbsp;body&nbsp;&amp;&nbsp;tail</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;body&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;len&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;head
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;bodySize&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;floor&nbsp;(body&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;rg)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;tail&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;body&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;rg<span style="color:#b4b4b4;">*</span>bodySize
 
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#57a64a;">//calculate&nbsp;gap&nbsp;&amp;&nbsp;return</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;headGap&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;head&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;headTouch
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;bodyGap&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;g&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;bodySize
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;tailGap&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;max&nbsp;<span style="color:#b5cea8;">0.0</span>&nbsp;(tail<span style="color:#b4b4b4;">-</span>r)
&nbsp;&nbsp;&nbsp;&nbsp;headGap&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;bodyGap&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;tailGap</pre>
        อันนี้คือสูตรหาความยาวของช่องว่าง<br />
        p คือจุดเริ่มต้น
        <br />
        len คือความยาวของเส้น<br />
        concept ในการหาจะมี head, body, tail<br />
        head คือ gap ระหว่างขอบจุดเริ่มต้น ไปแต่ขอบเอ็นเส้นแรก<br />
        body คือ ขนาดของ gap ระหว่างเส้นเอ็น ภายในเส้นตรง<br />
        tail คือ gap ระหว่างขอบเอ็นเส้นสุดท้าย กับจุดสิ้นสุดของเส้นตรง<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;touchString&nbsp;(x1,y1)&nbsp;(x2,y2)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;len&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;x2&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;x1
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;gapH&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;calculateGap&nbsp;x1&nbsp;len
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;gapV&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;calculateGap&nbsp;y1&nbsp;len
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;untouch&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(gapH&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;gapV)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;(len&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;len)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b5cea8;">1.0</span>&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;untouch</pre>
        function นี้ใช้คู่กับ function calculateGap<br />
        คือหาพื้นที่ของ gap หารด้วยพื้นที่ของสี่เหลี่ยม<br />
        ผลลัพธ์คือ โอกาสที่แมลงวันจะหลุดไปใน gap<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;rinMixRate&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(r&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;rg)&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;<span style="color:#b5cea8;">0.5</span>&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">0.5</span>
<span style="color:#569cd6;">let</span>&nbsp;getHitRate&nbsp;p1&nbsp;p2&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;a&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;center&nbsp;<span style="color:#b4b4b4;">&lt;-&gt;</span>&nbsp;p1
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;center&nbsp;<span style="color:#b4b4b4;">&lt;-&gt;</span>&nbsp;p2
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;b&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;R&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;a&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;R&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;(<span style="color:#b5cea8;">0.0</span>,&nbsp;<span style="color:#b5cea8;">0.0</span>),&nbsp;<span style="color:#569cd6;">false</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;(<span style="color:#b5cea8;">1.0</span>,&nbsp;<span style="color:#b5cea8;">0.5</span>),&nbsp;<span style="color:#569cd6;">true</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">elif</span>&nbsp;b&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;Rin&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;a&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;Rin
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;(<span style="color:#b5cea8;">1.0</span>,&nbsp;<span style="color:#b5cea8;">1.0</span>),&nbsp;<span style="color:#569cd6;">false</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;(rinMixRate,&nbsp;<span style="color:#b5cea8;">1.0</span>),&nbsp;<span style="color:#569cd6;">true</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(touchString&nbsp;p1&nbsp;p2,&nbsp;<span style="color:#b5cea8;">1.0</span>),&nbsp;<span style="color:#569cd6;">false</span>
</pre>
        ถัดมาคือการคำนวน ที่รวมขอบไม้<br />
        rinMixRate คือ โอกาสคร่าวๆ ที่แมลงวันจะรอดระหว่างขอบไม้กับเส้นเอ็นได้<br />
        p1 p2 คือจุดของสี่เหลี่ยม โดย p1 คือจุดซ้ายล่าง p2 คือ ขวาบน<br />
        a กับ b คือ ระยะระหว่าง จุดศูนย์กลางถึง p1 และ p2<br />
        operator (&lt;-&gt;) คือการหาระยะ อ่าน<a href="http://www.bloggang.com/viewblog.php?id=chaowman&amp;date=31-05-2014&amp;group=12&amp;gblog=4">ของเก่า</a>ดูครับ<br />
        <br />
        function นี้ return โอกาสที่ตีโดนแมลงวัน โอกาสที่อยู่ในไม้ และ สามารถแบ่งออกได้อีกหรือไม่<br />
        logic คือ ถ้าทั้ง p1 และ p2 อยู่นอกขอบไม้ โอกาสตีโดนคือ 0 โอกาสอยู่ในไม้คือ 0 และไม่ต้องแบ่งอีกแล้ว<br />
        ถ้า p2 อยู่นอกไม้ แต่ p1 อยู่ในไม้ โอกาสตีโดนคือ 1 โอกาสอยู่ในไม้คือ 0.5 และสามารถแบ่งเพื่อคำนวนให้ละเอียดขึ้นได้<br />
        ถ้าใน p1 และ p2 อยู่ระหว่างขอบไม้ด้านในกับด้านนอก ก็คือตีโดนแน่นอน<br />
        แต่ถ้า p2 อยู่ระหว่างขอบไม้ แต่ p1 อยู่ในวงกลม โอกาสคือ rinMixRate แต่สามารถแบ่งเพื่อคำนวนละเอียดขึ้นได้<br />
        สุดท้ายถ้า p1 และ p2 อยู่ในวงกลม ก็ใช้สูตรคำนวน touchString<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;epsilon&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0.00000025</span>&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;R
 
<span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;divide&nbsp;(x1,y1)&nbsp;(x2,y2)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;xHalf&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(x1&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;x2)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">2.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;yHalf&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(y1&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;y2)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">2.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;pos1,area1&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;conquer&nbsp;(x1,y1)&nbsp;(xHalf,yHalf)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;pos2,area2&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;conquer&nbsp;(x1,yHalf)&nbsp;(xHalf,y2)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;pos3,area3&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;conquer&nbsp;(xHalf,y1)&nbsp;(x2,yHalf)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;pos4,area4&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;conquer&nbsp;(xHalf,yHalf)&nbsp;(x2,y2)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;area&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;area1&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;area2&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;area3&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;area4
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;area&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#b5cea8;">0.0</span>,&nbsp;<span style="color:#b5cea8;">0.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;pos&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;pos1<span style="color:#b4b4b4;">*</span>area1&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;pos2<span style="color:#b4b4b4;">*</span>area2&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;pos3<span style="color:#b4b4b4;">*</span>area3&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;pos4<span style="color:#b4b4b4;">*</span>area4
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pos<span style="color:#b4b4b4;">/</span>area,&nbsp;area<span style="color:#b4b4b4;">/</span><span style="color:#b5cea8;">4.0</span>
 
<span style="color:#569cd6;">and</span>&nbsp;conquer&nbsp;(x1,y1)&nbsp;(x2,y2)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;hitRate,mix&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;getHitRate&nbsp;(x1,y1)&nbsp;(x2,y2)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;mix&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;x2<span style="color:#b4b4b4;">-</span>x1&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;epsilon
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;divide&nbsp;(x1,y1)&nbsp;(x2,y2)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;hitRate</pre>
        function สุดท้ายละ<br />
        epsilon คือ ขนาดที่เล็กที่สุดที่เราจะไม่คำนวนต่อ<br />
        divide คือ แบ่งสี่เหลี่ยมเป็นพื้นที่สี่ส่วนย่อย แล้วก็ conquer<br />
        ส่วน conquer คือ คำนวนหา hitRate ถ้าสามารถคำนวนละเอียดขึ้นได้ ก็ divide ไปเรื่อยๆ<br />
        <br />
        ด้านบนมีใช้ keyword &quot;and&quot; ใน f# คือ <a href="http://msdn.microsoft.com/en-us/library/dd233232.aspx">mutually recursive function</a> ครับ<br />
        <br />
        แล้วก็ print ผลลัพธ์<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;pop,_&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">if</span>&nbsp;g&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;<span style="color:#b5cea8;">0.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#b5cea8;">1.0</span>,&nbsp;<span style="color:#b5cea8;">1.0</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;conquer&nbsp;center&nbsp;(R,R)
sprintf&nbsp;<span style="color:#d69d85;">&quot;%.6f&quot;</span>&nbsp;pop</pre>
        จบ </div>
    </form>
</body>
</html>
