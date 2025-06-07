# ros1_program

> 机器人操作系统期末大作业：基于冰达NanoRobot_Pro的ros小车项目。

## 项目概述

这个开源项目提供了一个完整的ROS机器人实现方案，基于冰达NanoRobot_Pro。项目集成了SLAM建图、自主导航和动态避障功能，以及实现了多机协作功能。

1.完成机器人的激光 SLAM 建图功能。
2.完成机器人路径规划以及多点导航等功能。 
3.完成机器人多机协作功能，
4.确保系统各功能模块稳定运行，实现模块间的高效协同工作，并通过实测演示验证系统的可靠性。 
主要功能展示 
（一）激光雷达建图功能
激光 SLAM 建图：支持 Gmapping、Hector 等多种建图算法，通过 robot_slam_laser.launch 文件选择算法类型。建图过程中，激光雷达扫描环境生成点云数据，建图算法结合机器人运动数据构建二维栅格地图，地图包含障碍物区域和可通行区域，可通过 rviz 实时查看建图进度和最终地图。 
建图流程：
Step1：启动机器人SLAM建图
在桌面中打开一个终端，输入启机器人SLAM的命令
roslaunch robot_navigation robot_slam_laser.launch
Step2：启动可视化图形界面
在桌面中打开一个终端，输入启机器人SLAM的命令
roslaunch robot_navigation slam_rviz.launch
Step3：控制机器人在需要建图的区域移动
在桌面中打开一个终端，输入启机器人SLAM的命令
rosrun teleop_twist_keyboard teleop_twist_keyboard.py
Step4：保存地图
当机器人已经构建完你需要的区域的地图后，就可以将地图保存下来，用于后	续的导航实验
新打开一个终端，在终端中先输入下面切换目录的命令，然后再执行保存地图	命令
roscd robot_navigation/maps/ && rosrun map_server map_saver -f map

（二）自主导航功能 
路径规划与导航：在已知地图环境下，用户通过 rviz 或程序发送目标点，move_base 节点根据全局地图规划全局路径，使用局部路径规划算法（DWA 或 TEB）实时避开障碍物，控制机器人沿规划路径移动。对于阿克曼结构的机器人（如 NanoCar），TEB 算法支持设置最小转向半径、轮距等参数，实现更精准的路径规划。 
多点导航与全自动巡航：multi_points_navigation.launch 支持通过 rviz 按钮手动添加多个目标点，机器人按顺序完成导航；way_point.launch 可预设多个目标点坐标，启动后机器人自动依次导航，支持循环次数设置，适用于固定路线的巡航任务。 
导航流程：
①　启动导航 roslaunchSrobot_navigationSrobot_navigation.launchSsimulation:=true 如在实体机器人上运行则无需传入 simulation:=true 参数 
②　执行 rviz 图形化监控程序 roslaunchSrobot_navigationSnavigation_rviz.launch 
③　然后在 PC 端新开一个终端订阅/move_base_simple/goal 话题 
rostopicSechoS/move_base_simple/goal 
④　然后在 rviz 中通过“2DSNavSGoal”按钮让机器人导航到你想要巡航的第一个点，这时订阅 /move_base_simple/goal 话题会输出一个话题
 
⑤　然后再导航到你想要导航到的第二个点，以此类推，记录下你想要到导航所有点后
打开robot_navigation功能包下的way_point.launch文件进行修改

roslaunchrobot_navigationway_point.launchloopTimesloopTimes:=2 
这里我们loopTimes参数为巡航次数，默认为0次。设置为2则机器人在巡航点来回巡航
两遍后停止，如果设置为0则一直巡航。

（三）RViz 可视化 
通过 rviz 配置文件（如 slam.rviz、navigation.rviz）实时显示机器人模型、传感器数据（摄像头图像、激光雷达点云）、地图、路径规划结果、机器人位姿等信息，方便开发调试和功能演示。 
（四）多机器人控制 
通过两个键盘控制节点分别控制每台机器人
robot_0上启动机器人底盘节点，并指定机器人的命名空间为robot_0
roslaunch base_control base_control.launch robot_name:=robot_0
robot_1上启动机器人底盘节点，并指定机器人的命名空间为robot_1
roslaunch base_control base_control.launch robot_name:=robot_1
然后在任意一台设备上启动键盘控制节点
rosrun teleop_twist_keyboard teleop_twist_keyboard.py
在任意一台设备上启动cmd_vel 转发节点，指定控制机器人数量为 2
rosrun multi_robot cmd_vel_boardcast.py _robot_num:=2
