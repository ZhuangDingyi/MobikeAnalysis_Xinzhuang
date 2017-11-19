function FunctionAreaNum = GetFunctionArea_ifelse( LongLat)
%UNTITLED 此处显示有关此函数的摘要
% 输入变量必须满足为 [Long Lat]形式的一维向量
%   此处显示详细说明
Long=LongLat(1);
Lat=LongLat(2);
if (Long>=121.4316610849&&Long<=121.4441982241&&Lat>=31.0360417300&&Lat<=31.0347537147)
        FunctionAreaNum=1;
    else if  (Long>=121.4327125108&&Long<=121.4384953535&&Lat>=31.0322989736&&Lat<=31.0323449431)
            FunctionAreaNum=1;
        else if (Long>=121.4364783323&&Long<=121.4395647435&&Lat>=31.0299821009&&Lat<=31.0316462041)
                FunctionAreaNum=1;
            else if (Long>=121.4378266721&&Long<=121.4411847978&&Lat>=31.0261480721&&Lat<=31.0279961484)
                    FunctionAreaNum=1;
                else if (Long>=121.4408736615&&Long<=121.4446049458&&Lat>=31.0270337084&&Lat<=31.0304969707)
                        FunctionAreaNum=1;
                    else if (Long>=121.4393429315&&Long<=121.4419237108&&Lat>=31.0328239352&&Lat<=31.0343032239)
                            FunctionAreaNum=1;
                        else if (Long>=121.4294946078&&Long<=121.4332167661&&Lat>=31.0322897797&&Lat<=31.0338814638)
                                FunctionAreaNum=2;
                            else if (Long>=121.4320974736&&Long<=121.4363675504&&Lat>=31.0248884174&&Lat<=31.0276559579)
                                    FunctionAreaNum=2;
                                else if (Long>=121.4358632951&&Long<=121.4389317422&&Lat>=31.0256055951&&Lat<=31.0286305544)
                                        FunctionAreaNum=2;
                                    else if (Long>=121.4426522976&&Long<=121.4455490834&&Lat>=31.0274750392&&Lat<=31.0310791645)
                                            FunctionAreaNum=2;
                                        else if (Long>=121.4335726886&&Long<=121.4376979261&&Lat>=31.0237712645&&Lat<=31.0242218051)
                                                FunctionAreaNum=2;
                                            else if (Long>=121.4460543127&&Long<=121.4418056936&&Lat>=31.0321068118&&Lat<=31.0328147413)
                                                    FunctionAreaNum=2;
                                                else if (Long>=121.4370220094&&Long<=121.4419012791&&Lat>=31.0251488349&&Lat<=31.0250631150)
                                                        FunctionAreaNum=4;
                                                    else if (Long>=121.4375691800&&Long<=121.4402084737&&Lat>=31.0285753888&&Lat<=31.0292281794)
                                                            FunctionAreaNum=4;
                                                        else if (Long>=121.4397578626&&Long<=121.4429419762&&Lat>=31.0263257359&&Lat<=31.0300740422)
                                                                FunctionAreaNum=4;
                                                            else if (Long>=121.4430395098&&Long<=121.4552614724&&Lat>=31.0349674496&&Lat<=31.0384320214)
                                                                    FunctionAreaNum=5;
                                                                else if(Long>=121.4436832399&&Long<=121.4567460701&&Lat>=31.0306892923&&Lat<=31.0317390541)
                                                                        FunctionAreaNum=5;
                                                                    else if(Long>=121.4334493070&&Long<=121.4375369935&&Lat>=31.0294488400&&Lat<=31.0306624640)
                                                                            FunctionAreaNum=5;
                                                                        else if(Long>=121.4304387454&&Long<=121.4346723943&&Lat>=31.0285110290&&Lat<=31.0316289702)
                                                                                FunctionAreaNum=5;
                                                                            else if(Long>=121.4344256311&&Long<=121.4374940782&&Lat>=31.0252194231&&Lat<=31.0284466690)
                                                                                    FunctionAreaNum=3;
                                                                                else if(Long>=121.4407234578&&Long<=121.4573576138&&Lat>=31.0299767506&&Lat<=31.0261940445)
                                                                                        FunctionAreaNum=3;
                                                                                    else if(Long>=121.4401690519&&Long<=121.4427381283&&Lat>=31.0310056123&&Lat<=31.0322530041)
                                                                                            FunctionAreaNum=3;
                                                                                        else if (Long>=121.4409522569&&Long<=121.4452281923&&Lat>=31.0338260601&&Lat<=31.0348088767)
                                                                                                FunctionAreaNum=3;
                                                                                            else if (Long<121.4294731502||Long>121.4573576138||Lat>31.0338354951||Lat<31.0299767506)
                                                                                                    FunctionAreaNum=6;
                                                                                                else 
                                                                                                    FunctionAreaNum=0;
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
end
end

