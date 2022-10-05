echo "Starting 'core'"
screen -S core -d -m 'ssh locobot@locobot "cd bucky_ws;source devel/setup.bash;roslaunch interbotix_xslocobot_control xslocobot_control.launch robot_model:=locobot_wx250s use_base:=true use_camera:=true use_lidar:=true"'
sleep 2
echo "Starting 'clientsubscriber'"
screen -S clientsubscriber -d -m 'ssh locobot@locobot "cd bucky_ws;source devel/setup.bash;rosrun robonotts_object_detection test_refbox_client_subscriber.py"'
echo "Starting 'darknet'"
screen -S darknet -d -m 'ssh locobot@locobot "cd bucky_ws;source devel/setup.bash;roslaunch darknet_ros darknet_ros.launch"'
echo "Starting 'drake'"
source ~/metrics_ws/devel/setup.bash
screen -S drake -d -m 'rosrun drake drake_node --image=/locobot/camera/color/image_raw'

read -p "View [D]rake bounding boxes, D[A]rknet bounding boxes, [C]amera, or [N]othing?" -n 1 -r
echo
case $REPLY in
	[Dd]* ) imgstream=/drake/image_with_bounding_boxes;;
	[Aa]* ) echo "Not implemented";;
	[Cc]* ) imgstream=/locobot/camera/color/image_raw;;
	* ) echo "...";;
esac

screen -S imgview -d -m "rosrun image_view image_view image:=$imgstream"
