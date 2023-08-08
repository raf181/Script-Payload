# Set the server IP address or hostname
Dsever_Local="192.168.0.37"
Dsever_Remote="79.108.73.183"
# Set the SSH port 
port_one=1811
port_two=1812

# Try to connect to the server via SSH
if ssh -q -o ConnectTimeout=5 -p $port_one $Dsever_Remote exit >/dev/null 2>&1; then
    Dsever_Remote_available="Avaliable"
else
    Dsever_Remote_available="Not Avaliable"
fi
if ssh -q -o ConnectTimeout=5 -p $port_two $Dsever_Remote exit >/dev/null 2>&1; then
    Dsever_Remote_available="Avaliable"
else
    Dsever_Remote_available="Not Avaliable"
fi

if ssh -q -o ConnectTimeout=5 -p $port_one $Dsever_Local exit >/dev/null 2>&1; then
    Dsever_Local_available="Avaliable"
else
    Dsever_Local_available="Not Avaliable"
fi

if ssh -q -o ConnectTimeout=5 -p $port_two $Dsever_Local exit >/dev/null 2>&1; then
    Dsever_Local_available="Avaliable"
else
    Dsever_Local_available="Not Avaliable"
fi

echo Sever conection checks:
echo.
echo Remote conections:
echo  Dserver port 1811: $Dsever_Remote_available
echo Dserver port 1812: $Dsever_Remote_available
echo.
echo Local conections:
echo Dserver port 1811: $Dsever_Local_available
echo Dserver port 1812: $Dsever_Local_available
echo.