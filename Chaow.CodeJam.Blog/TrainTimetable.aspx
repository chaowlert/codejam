<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TrainTimetable.aspx.cs" Inherits="Chaow.CodeJam.Blog.TrainTimetable" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        คราวนี้สมมติว่าเราเป็นผู้จัดการรถไฟ<br />
        ซึ่งมีแค่ 2 สถานี คือ A กับ B<br />
        A กับ B มีตารางออกจากสถานีแน่นอน มีระยะเวลาเดินทางแน่นอน และมีระยะเวลาพักรถแน่นอน<br />
        เราต้องหาว่า เราต้องหารถมาวางไว้ที่สถานี A กี่คัน และสถานี B กี่คัน<br />
        อ่านต่อ <a href="https://code.google.com/codejam/contest/32013/dashboard#s=p1">ที่นี่</a><br />
        <br />
        วิธีคิดก็เอาตารางเวลามาเรียงกันทั้งหมด เราหยิบเที่ยวที่ออกเช้าสุดออกมา<br />
        เมื่อเดินไปถึงอีกสถานีนึง เราก็มาดูว่าตารางเวลาถัดไปของอีกสถานีนึงคืออะไร แล้วก็ตัดไปเรื่อยๆ<br />
        <br />
        เริ่มกันเลย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;t&nbsp;set&nbsp;<span style="color:#b4b4b4;">=</span></pre>
        t คือระยะเวลาพักรถ<br />
        set คือ Set ของตารางเวลาซึ่งเป็น tuple ซึ่งเรียงดังนี้ เวลาออก เวลาถึง สถานี id<br />
        สถานีผมใช้เป็น boolean ถ้าเป็น true คือ สถานี A ถ้า false คือ สถานี B<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;runTrip&nbsp;startTime&nbsp;station&nbsp;set&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;findFn&nbsp;(dep,_,i,_)&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;dep&nbsp;<span style="color:#b4b4b4;">&gt;=</span>&nbsp;startTime&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;i&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;station
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>tryFind&nbsp;findFn&nbsp;set&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;None&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;set
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Some(it)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;_,arr,_,_&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;it
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;runTrip&nbsp;(arr<span style="color:#b4b4b4;">+</span>t)&nbsp;(not&nbsp;station)&nbsp;(<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>remove&nbsp;it&nbsp;set)</pre>
        ถัดมาคือ function เดินรถ เช่น เดินรถจาก A ไป B ถึง B กี่โมง สามารถออกจาก B ไป A ได้อีกหรือไม่<br />
        ถ้าได้ (Some(it)) ก็ตัดออกจาก set ไปเรื่อยๆ
        <br />
        แต่ถ้าไม่ได้ (None) ก็คืนค่า set ที่ถูกตัดออกไป<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;startTrip&nbsp;a&nbsp;b&nbsp;set&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;set&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>empty
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;a,&nbsp;b
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;startTime,_,station,_&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;set<span style="color:#b4b4b4;">.</span>MinimumElement
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newSet&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;runTrip&nbsp;startTime&nbsp;station&nbsp;set
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;station
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;startTrip&nbsp;(a<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">1</span>)&nbsp;b&nbsp;newSet
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;startTrip&nbsp;a&nbsp;(b<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">1</span>)&nbsp;newSet</pre>
        และถัดมาคือ function ดูว่าต้องมีรถที่ A และ B อย่างละเท่าไหร่<br />
        หลักการคือ เอารถเที่ยวแรกออกมา แล้วโยนเข้าไปใน runTrip ก็จะได้ set ใหม่ที่หักตารางของรถคันนี้ออกไป<br />
        วนไปเรื่อยๆ จนไม่มี item ใน set (Set.empty) จะได้คำตอบออกมา<br />
        <br />
        สุดท้ายคืนค่า<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;a,&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;startTrip&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;set
sprintf&nbsp;<span style="color:#d69d85;">&quot;</span><span style="color:#4edcb0;">%A</span><span style="color:#d69d85;">&nbsp;</span><span style="color:#4edcb0;">%A</span><span style="color:#d69d85;">&quot;</span>&nbsp;a&nbsp;b</pre>
        จบ</div>
    </form>
</body>
</html>
