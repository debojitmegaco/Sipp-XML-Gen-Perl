 #Script to generate XML file for SIPp
 #Author: Debojit Bhadra
 #Date:31/03/2014       
 
 
 
 #-------------------------------------------
 #Count the number of states
 #-------------------------------------------
 open (FILE, 'C:\Perl\data.txt');
 $i=0; $j=0;
 $UAC_CSEQ=0;
 $UAS_CSEQ=0;
 
 open (MYFILE, '>C:\Perl\UAC.xml');
 #Counting number of nodes
 while (<FILE>) 
  {
 chomp;
  (@node[$j]) = split("\t");
  $j=$j+1;
  }
 close (FILE);
 $state=@node;
 print "Number of Nodes : $state\n";
 
 #-------------------------------------------
 #Begin Generate XML
 #-------------------------------------------
 
 open (FILE, 'C:\Perl\data.txt');
 
while (<FILE>) 
  {
 chomp;
  (@node[$i]) = split("\t");
   print "node[$i]: @node[$i]\n";
   
   #Create XML for S_INVITE
   if (@node[$i] eq '"S_INVITE"')
   {
    $UAC_CSEQ=$UAC_CSEQ+1;
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
    <send>
    <![CDATA[

      INVITE sip:ivr@[remote_ip]:[remote_port] SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: sipp <sip:sipp@[local_ip]:[local_port]>;tag=[pid]SIPpTag00[call_number]
      To: sut <sip:ivr@[remote_ip]:[remote_port]>
      Call-ID: [call_id]
      CSeq: 1 INVITE
      x-nt-corr-id: 0000001d0f21100202@e8056dfe444e-0a24fa0a
      Contact: sip:sipp@[local_ip]:[local_port]
      Max-Forwards: 70
      Subject: Performance Test
      Content-Type: application/sdp
      Content-Length: [len]

      v=0
      o=user1 53655765 2353687637 IN IP[local_ip_type] [local_ip]
      s=-
      c=IN IP[media_ip_type] [media_ip]
      t=0 0
      m=audio [media_port] RTP/AVP 0
      a=sendrecv
      a=ptime:20
      a=rtpmap:0 PCMU/8000

    ]]>
   </send>\n";
    close (MYFILE); 
   }
   
    #Create XML for R_183
   if (@node[$i] eq '"R_183"')
   {
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
    <recv response= \"183|180|200\">
    </recv> \n";
    close (MYFILE); 
   }
   
    #Create XML for R_200_INVITE
   if (@node[$i] eq '"R_200_INVITE"')
   {
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
    <recv response= \"200\">
    </recv> \n";
    close (MYFILE); 
   }
   
    #Create XML for S_ACK_INVITE
   if (@node[$i] eq '"S_ACK_INVITE"')
   {
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
    <send>
    <![CDATA[

      ACK sip:ivr@[remote_ip]:[remote_port] SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: sipp <sip:sipp@[local_ip]:[local_port]>;tag=[pid]SIPpTag00[call_number]
      To: sut <sip:ivr@[remote_ip]:[remote_port]>[peer_tag_param]
      Call-ID: [call_id]
      CSeq: 1 ACK
      Contact: sip:sipp@[local_ip]:[local_port]
      Max-Forwards: 70
      Subject: Performance Test
      Content-Length: [len]

    ]]>
   </send> \n";
    close (MYFILE); 
   }
   
   #Create XML for S_INFO
   if (@node[$i] eq '"S_INFO"')
   {
    $UAC_CSEQ=$UAC_CSEQ+1;
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
    <send>
    <![CDATA[

      INFO sip:ivr@[remote_ip]:[remote_port] SIP/2.0
      From: sipp <sip:sipp@[local_ip]:[local_port]>;tag=[pid]SIPpTag00[call_number]
      To: sut <sip:ivr@[remote_ip]:[remote_port]>[peer_tag_param]
      Call-ID: [call_id]
      CSeq: $UAC_CSEQ INFO
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      Contact: sip:sipp@[local_ip]:[local_port]
      Max-Forwards: 70
      Allow: INVITE, CANCEL, ACK, BYE, OPTIONS, INFO
      Content-Type: application/xml
      Content-Length: [len]

     INPUT BODY
     
    ]]>
  </send> \n";
    close (MYFILE); 
   }
   
   #Create XML for R_200
   if (@node[$i] eq '"R_200"')
   {
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
     <recv response=\"200\" >
     </recv> \n";
    close (MYFILE); 
   }
   
    #Create XML for R_INFO
   if (@node[$i] eq '"R_INFO"')
   {
    $UAS_CSEQ=$UAS_CSEQ+1;
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
     <recv request=\"INFO\" >
     </recv> \n";
    close (MYFILE); 
   }
   
   #Create XML for R_INVITE
   if (@node[$i] eq '"R_INVITE"')
   {
    $UAS_CSEQ=$UAS_CSEQ+1;
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
     <recv request=\"INVITE\" >
     </recv> \n";
    close (MYFILE); 
   }
   
    #Create XML for S_200
   if (@node[$i] eq '"S_200"')
   {
    $UAS_CSEQ=$UAS_CSEQ+1;
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
     <send>
    <![CDATA[

      SIP/2.0 200 OK
      [last_Via:]
      [last_From:]
      [last_To:]
      [last_Call-ID:]
      [last_CSeq:]
      Contact: <sip:[local_ip]:[local_port];transport=[transport]>
      Content-Length: [len]

    ]]>
  </send> \n";
    close (MYFILE); 
   }
   
   #Create XML for R_BYE
   if (@node[$i] eq '"R_BYE"')
   {
    $UAS_CSEQ=$UAS_CSEQ+1;
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
     <recv request=\"BYE\" >
     </recv> \n";
    close (MYFILE); 
   }
   
   
   #Create XML for S_BYE
   if (@node[$i] eq '"S_BYE"')
   {
    $UAC_CSEQ=$UAC_CSEQ+1;
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
     <send>
    <![CDATA[

      BYE sip:ivr@[remote_ip]:[remote_port]  SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: sipp <sip:sipp@[local_ip]:[local_port]>;tag=[pid]SIPpTag00[call_number]
      To: sut <sip:ivr@[remote_ip]:[remote_port]>[peer_tag_param]
      Call-ID: [call_id]
      CSeq: $UAC_CSEQ BYE
      Contact: sip:sipp@[local_ip]:[local_port]
      Max-Forwards: 70
      Subject: Performance Test
      Content-Length: [len]

    ]]>
   </send> \n";
    close (MYFILE); 
   }
   
   #Create XML for PAUSE
   if (@node[$i] =~ /"PAUSE/)
   {
    $temp=@node[$i];
    $temp =~ m/(\d+)/;
    $num = $1;
    open (MYFILE, '>>C:\Perl\UAC.xml');
    print MYFILE "
     <pause milliseconds=\"$num\"/>\n";
    close (MYFILE); 
   }
     
   $i=$i+1;
  }
  
  print "VIOLA YOUR SCRIPT IS READY";  

 close (FILE);
 exit;
