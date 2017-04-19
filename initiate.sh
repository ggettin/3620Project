headNode="clnode172"
compute1Node="clnode173"
compute2Node="clnode170"
compute3Node="clnode169"
fatNode="clnode167"
scratchNode="clnode175"

headPass="88349650cae7"
compute1Pass="5701dcdd86d7"
compute2Pass="8d3efa89e083"
compute3Pass="d984550214f5"
fatPass="c960ae8b5cf4"
scratchPass="64c24bb2b1e9s"



ssh -o StrictHostKeyChecking=no -p 22 -t ggettin@$headNode.clemson.cloudlab.us -t 'echo $headPass | sudo yum -y install git; echo $headPass | sudo git clone https://github.com/ggettin/3620Project.git /Project; cd /Project/; echo $headPass | sudo chmod +x *.sh; echo $headPass | sudo ./headfirst.sh'

ssh -o StrictHostKeyChecking=no -p 22 -t ggettin@$scratchNode.clemson.cloudlab.us -t 'echo $scratchPass | sudo yum -y install git; echo $scratchPass | sudo git clone https://github.com/ggettin/3620Project.git /Project; cd /Project/; echo $scratchPass | sudo chmod +x *.sh; echo $scratchPass | sudo ./scratch.sh'

ssh -o StrictHostKeyChecking=no -p 22 -t ggettin@$compute1Node.clemson.cloudlab.us -t 'echo $compute1Pass || sudo yum -y install git; echo $compute1Pass | sudo git clone https://github.com/ggettin/3620Project.git /Project; cd /Project/; echo $compute1Pass | sudo chmod +x *.sh; echo $compute1Pass | sudo ./compute1.sh'

ssh -o StrictHostKeyChecking=no -p 22 -t ggettin@$compute2Node.clemson.cloudlab.us -t 'echo $compute2Pass | sudo yum -y install git; echo $compute2Pass | sudo git clone https://github.com/ggettin/3620Project.git /Project; cd /Project/; echo $compute2Pass | sudo chmod +x *.sh; echo $compute2Pass | sudo ./compute2.sh'

ssh -o StrictHostKeyChecking=no -p 22 -t ggettin@$compute3Node.clemson.cloudlab.us -t 'echo $compute3Pass | sudo yum -y install git; echo $compute3Pass | sudo git clone https://github.com/ggettin/3620Project.git /Project; cd /Project/; echo $compute3Pass | sudo chmod +x *.sh; echo $compute3Pass | sudo ./compute3.sh'

ssh -o StrictHostKeyChecking=no -p 22 -t ggettin@$fatNode.clemson.cloudlab.us -t 'echo $fatPass | sudo yum -y install git; echo $fatPass | sudo git clone https://github.com/ggettin/3620Project.git /Project; cd /Project/; echo $fatPass | sudo chmod +x *.sh; echo $fatPass | sudo ./fat.sh'

ssh -o StrictHostKeyChecking=no -p 22 -t ggettin@$headNode.clemson.cloudlab.us -t 'cd /Project/; echo $headPass | sudo ./headsecond.sh'
