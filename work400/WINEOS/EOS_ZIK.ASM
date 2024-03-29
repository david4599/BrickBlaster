;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;�                                                                          �
;�                                                                          �
;쿏efinition de Toutes les Fonctions Utilisees par L'EOS pour la Partie     �
;쿭e la musique                                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
SDATA
ifndef WIN32
Global      Detect_Sound_Card_Diamond       : Proc
Global      Start_Playing_Diamond           : Proc
Global      Stop_Playing_Diamond            : Proc
Global      Initialise_Player_Diamond       : Proc
Global      Clear_Module_Diamond            : Proc
Global      Manual_Setup_Diamond            : Proc
endif

Global      Play_Sample_Diamond             : Proc
Handle_Mod  dd 0

;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿏etect Sound Card   Detect with the environment varialble the sound       �
;�                    card installed                                        �
;�                                                                          �
;쿔n :                                                                      �
;�        AH = Detect_Sound_Card                                            �
;�        CX = 1  Display result of Searching                               �
;�                                                                          �
;쿚ut :                                                                     �
;�        AX = 0  No_Card                                                   �
;�           = 1  Sound Blaster 1.0                                         �
;�           = 2  Sound Blaster 1.5                                         �
;�           = 3  Sound Blaster 2.0                                         �
;�           = 4  Sound Blaster Pro                                         �
;�           = 5  Sound Blaster 16                                          �
;�           = 6  Sound Blaster Awe 32                                      �
;�           = 10h  Gus                                                     �
;�           = 11h  Gus Max                                                 �
;�           = 12h  Gus Ace                                                 �
;�           = 13h  Gus Pnp                                                 �
;�           = 20h  WSS                                                     �
;�        BX = Port                                                         �
;�        CX = Irq                                                          �
;�        DX = Dma                                                          �
;�        SI = Dsp Version (For Sb) ou                                      �
;�             Size of RAM of the Gravis                                    �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Detect_Sound_Card_EOS:
ifndef WIN32
            PushDS
            PushES
            mov ax,_CS[Data32_Sel]
            mov ds,ax
            mov es,ax
            Call Detect_Sound_Card_Diamond
            PopES
            PopDS
else
            mov eax,0ffh
            xor ebx,ebx
            xor ecx,ecx
            xor edx,edx
            xor esi,esi
endif
            mIRETD


;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿗oad Module   Load a module & initialize into the memory                  �
;�                                                                          �
;쿔n :                                                                      �
;�        AH = Load_Module                                                  �
;�        AL = Bit 0 = 1  Load a internal module (can be compress and link  �
;�                        with LLINK)                                       �
;�           = Bit 1 = 1  Load module  from memory                          �
;�           = Bit 2 = 1  Force old mod Loading (15 instr)                  �
;�        BX = Replay rate (16000 to 441000 Hz)                             �
;�        CX = Number of Sfx Channel                                        �
;�        DS:EDX = Offset of Module name or                                 �
;�                 Offset into the memory of the beginning of the module    �
;�                                                                          �
;쿚ut :                                                                     �
;�        Carry = 0                                                         �
;�             All Done                                                     �
;�                                                                          �
;�        Carry = 1                                                         �
;�             Can't Load Module                                            �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Load_Module_EOS:
            cmp _CS[Handle_Mod],0
            jne @@Ok12
            pushad
            test al,2
            jne @@Ok2
            mov ah,Load_External_File_Handle
            test al,1
            je @@Ok1
            mov ah,Load_Internal_File_Handle
@@Ok1:
            push ecx
            Int_EOS
            jc @@Ok10
            PushDS
            LoadDS
            mov [Handle_Mod],edi
            PopDS
            mov edx,eax
@@Ok2:
            pop eax
ifndef WIN32
            PushDS
            PushES
            mov esi,edx
            mov dx,_CS[Data32_Sel]
            mov ds,dx
            mov es,dx
            call Initialise_Player_Diamond
            PopES
            PopDS
            jc @@Ok11
else
            CCALL LSYS_InitModule,esi,ecx,eax
            test eax,eax
            je @@Ok11
            CCALL LSYS_PlayModule,[Handle_Mod]
endif
            popad
            mov eax,1
            Clear_Carry
            mIRETD

@@Ok10:
            pop ecx
@@Ok11:
            mov ah,DeAllocate_Memory_Handle
            mov edi,_CS[Handle_Mod]
            Int_EOS
            popad
@@Ok12:
            xor eax,eax
            Set_Carry
            mIRETD


;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿛lay Module   Start playing the module                                    �
;�                                                                          �
;쿔n :                                                                      �
;�        AH = Play_Module                                                  �
;�                                                                          �
;쿚ut :                                                                     �
;�        Carry = 0                                                         �
;�             All Done                                                     �
;�                                                                          �
;�        Carry = 1                                                         �
;�             Can't Play Module                                            �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Play_Module_EOS:
ifndef WIN32
            pushad
            PushDS
            PushES
            mov ax,_CS[Data32_Sel]
            mov ds,ax
            mov es,ax
            Call Start_Playing_Diamond
            jc @@Ok10
            PopES
            PopDS
            popad
            Clear_Carry
            mIRETD
@@Ok10:
            PopES
            PopDS
            popad
            Set_Carry
            mIRETD
else
            pushad
            CCALL LSYS_ResumeModule
            popad
            Clear_Carry
            mIRETD
endif


;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿞top Module   Stop playing module                                         �
;�                                                                          �
;쿔n :                                                                      �
;�        AH = Stop_Module                                                  �
;�                                                                          �
;쿚ut :                                                                     �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Stop_Module_EOS:
            pushad
ifndef WIN32
            PushDS
            PushES
            mov ax,_CS[Data32_Sel]
            mov ds,ax
            mov es,ax
            Call Stop_Playing_Diamond
            PopES
            PopDS
else
            CCALL LSYS_PauseModule
endif
            popad
            mIRETD

;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿎lear Module   Unload the module from memory                              �
;�                                                                          �
;쿔n :                                                                      �
;�        AH = Clear_Module                                                 �
;�                                                                          �
;쿚ut :                                                                     �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Clear_Module_EOS:
            pushad
ifndef WIN32
            PushDS
            PushES
            mov ax,_CS[Data32_Sel]
            mov ds,ax
            mov es,ax
            Call Stop_Playing_Diamond
            xor edi,edi
            mov ah,DeAllocate_Memory_Handle
            xchg edi,[Handle_Mod]
            Int_EOS
            Call Clear_Module_Diamond
            PopES
            PopDS
else
            CCALL LSYS_PauseModule
            CCALL LSYS_StopModule
            CCALL LSYS_ReleaseModule,[Handle_Mod]
            mov ah,DeAllocate_Memory_Handle
            xor edi,edi
            xchg edi,[Handle_Mod]
            Int_EOS
endif
            popad
            mIRETD

;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿘anual Setup Sound Card                                                   �
;�                                                                          �
;쿔n :                                                                      �
;�        AL = Type                                                         �
;�        BX = Port                                                         �
;�        CL = Irq1                                                         �
;�        CH = Irq2      ; Irq Gus 2                                        �
;�        DL = Dma1      ; Dma Gus 1 or Dma 8 Bits for SB                   �
;�        DH = Dma2      ; Dma Gus 2 or Dma 16 Bits for SB                  �
;�                                                                          �
;쿚ut :                                                                     �
;�        Carry Off                                                         �
;�        Init Ok                                                           �
;�                                                                          �
;�        Carry On                                                          �
;�        No Sound Card Found                                               �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Manual_Setup_EOS:
ifndef WIN32
            call Manual_Setup_Diamond
            jc @@Ok1
            Clear_Carry
            mIRETD
@@Ok1:
            Set_Carry
            mIRETD
else
            Clear_Carry
            ret
endif


;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿞et Volume   Set the master volume of the module                          �
;�                                                                          �
;쿔n :                                                                      �
;�        AH = Set_Volume                                                   �
;�        BL = Volume (0 to 63)                                             �
;�        CL = Sfx Volume (0 to 63)                                         �
;�                                                                          �
;쿚ut :                                                                     �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Set_Volume_EOS:
ifndef WIN32
            PushDS
            LoadDS
            mov [Master_Volume],bl
            mov [Master_Volume_Sfx],cl
            PopDS
            mIRETD
else
            pushad
            and ebx,0ffh
            and ecx,0ffh
            CCALL LSYS_SetModuleVolume,ebx,ecx
            popad
            mIRETD
endif

;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿗oad Sample   Load a sample & initialize into the memory                  �
;�                                                                          �
;쿔n :                                                                      �
;�        AH = Load_Sample                                                  �
;�        AL = Bit 0 = 1  Load a internal module (can be compress and link  �
;�                        with LLINK)                                       �
;�        DS:EDX = Offset of Sample name or                                 �
;�                 Offset into the memory of the beginning of the sample    �
;�                                                                          �
;쿚ut :                                                                     �
;�        Carry = 0                                                         �
;�             All Done                                                     �
;�                                                                          �
;�        Carry = 1                                                         �
;�             Can't Load Module                                            �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Load_Sample_EOS:
            push ebx
            push ecx
            push edx
            push esi
            push edi
            mov ah,Load_External_File_Handle
            test al,1
            je @@Ok1
            mov ah,Load_Internal_File_Handle
@@Ok1:
            Int_EOS
            jc @@Ok11
            mov edx,eax
ifndef WIN32
else
            CCALL _Load_External_Sample,edx
            jc @@Ok10
endif
            pop edi
            pop esi
            pop edx
            pop ecx
            pop ebx
            Clear_Carry
            mIRETD
@@Ok10:
            mov ah,DeAllocate_Memory_Handle
            Int_EOS
@@Ok11:
            pop edi
            pop esi
            pop edx
            pop ecx
            pop ebx
            Set_Carry
            mIRETD



;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿛lay Sample   Play a sample include into the module                       �
;�                                                                          �
;쿔n :                                                                      �
;�        AH = Play_Sample                                                  �
;�        BX = Sample numbers                                               �
;�        CX = Sample Frequecy                                              �
;�        DX = voice of sample                                              �
;�                                                                          �
;쿚ut :                                                                     �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Play_Sample_EOS:
            pushad
ifndef WIN32
            PushDS
            PushES
            mov ax,_CS[Data32_Sel]
            mov ds,ax
            mov es,ax
endif
            call Play_Sample_Diamond
ifndef WIN32
            PopES
            PopDS
endif
            popad
            mIRETD


;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿒et Info   Get information about the module when playing                  �
;�                                                                          �
;쿔n:                                                                       �
;�        AH = Get_Info                                                     �
;�                                                                          �
;쿚ut:                                                                      �
;�        AH = Position                                                     �
;�        AL = Pattern                                                      �
;�        BX = Note                                                         �
;�        CL = Master Volume                                                �
;�        DL = Master Volume Sfx                                            �
;�                                                                          �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Get_Info_EOS:
            PushDS
            LoadDS
            mov ah,B [Index_Pattern_Order]
            mov al,[Current_Pattern]
            movzx bx,[Current_Note]
            mov cl,[Master_Volume]
            mov dl,[Master_Volume_Sfx]
            PopDS
            mIRETD


;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;쿞et Pattern  Set the current position of the playing module               �
;�                                                                          �
;쿔n:                                                                       �
;�        AH = Set_Pattern                                                  �
;�        BX = New_Position                                                 �
;�        CX = New_Note                                                     �
;�                                                                          �
;쿚ut:                                                                      �
;�                                                                          �
;쿚ther Registers Change : None                                             �
;�                                                                          �
;�                                                                          �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Set_Pattern_EOS:
            PushDS
            push ebx
            LoadDS
;            test cl,cl
;            jne @@Ok1
;            dec bx
;            mov cl,64
;@@Ok1:
;            test bx,bx
;            jns @@Ok2
;            mov ebx,-1
;            mov cl,64
;@@Ok2:
            movsx ebx,bx
            mov [Index_Pattern_Order],ebx
            mov bl,[Pattern_Order+ebx]
            mov [Current_Pattern],bl
            mov [Current_Note],cl
            pop ebx
            PopDS
            mIRETD