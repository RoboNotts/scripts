echo "Starting Core..."
ssh locobot@locobot "cd bucky_ws;source devel/setup.bash;roslaunch interbotix_xslocobot_control xslocobot_control.launch robot_model:=locobot_wx250s use_base:=true use_camera:=true use_lidar:=true">/dev/null &
sleep 2
echo "Starting Object Detection..."
ssh locobot@locobot "cd bucky_ws;source devel/setup.bash;rosrun robonotts_object_detection test_refbox_client_subscriber.py">/dev/null &
echo "Starting Darknet..."
ssh locobot@locobot "cd bucky_ws;source devel/setup.bash;roslaunch darknet_ros darknet_ros.launch">/dev/null &
echo "Starting Drake..."
source ~/metrics_ws/devel/setup.bash
rosrun drake drake_node --image=/locobot/camera/color/image_raw &

read -p "View [D]rake bounding boxes, D[A]rknet bounding boxes, [C]amera, or [N]othing?" -n 1 -r
echo
case $REPLY in
	[Dd]* ) imgstream=/drake/image_with_bounding_boxes;;
	[Aa]* ) echo "Not implemented";;
	[Cc]* ) imgstream=/locobot/camera/color/image_raw;;
	* ) echo "...";;
esac

rosrun image_view image_view image:=$imgstream
