/*

              ::::::::::: :::::::::: ::::    ::: :::    ::: ::::::::::: ::::    :::  ::::::::  :::::::::: ::::::::::: :::        ::::::::::
                 :+:     :+:        :+:+:   :+: :+:   :+:      :+:     :+:+:   :+: :+:    :+: :+:            :+:     :+:        :+:
                +:+     +:+        :+:+:+  +:+ +:+  +:+       +:+     :+:+:+  +:+ +:+        +:+            +:+     +:+        +:+
               +#+     +#++:++#   +#+ +:+ +#+ +#++:++        +#+     +#+ +:+ +#+ +#++:++#++ :#::+::#       +#+     +#+        +#++:++#
              +#+     +#+        +#+  +#+#+# +#+  +#+       +#+     +#+  +#+#+#        +#+ +#+            +#+     +#+        +#+
         #+# #+#     #+#        #+#   #+#+# #+#   #+#      #+#     #+#   #+#+# #+#    #+# #+#            #+#     #+#        #+#
         #####      ########## ###    #### ###    ### ########### ###    ####  ########  ###        ########### ########## ##########

      Welcome to the intelligent automation process 'Jenkinsfile'management script, All rights reserved, please obtain Nings’s license before use,
unlicensed, illegal reproduction, use and so on are strictly prohibited.
*/

//导入模块
import java.text.SimpleDateFormat
import groovy.json.*

pipeline {
	//选择代理机
	agent any
	//选项参数
	options {
        //pipeline保持构建的最大个数
        buildDiscarder(logRotator(numToKeepStr: '5'))
        //不允许并行执行Pipeline,可用于防止同时访问共享资源等
        disableConcurrentBuilds()
        //默认跳过来自源代码控制的代码
        //skipDefaultCheckout()
        //一旦构建状态进入了“Unstable”状态，就跳过此stage
        skipStagesAfterUnstable()
        //设置Pipeline运行的超时时间
        timeout(time: 10, unit: 'HOURS')
        //失败后，重试整个Pipeline的次数
        retry(1)
        //在控制台打印所有操作的时间戳
        timestamps()
     }
	//定义构建参数
	parameters {
		booleanParam name: 'CLOUD', description: '是否上云',  defaultValue: false
		choice name: 'DEPLOY_ENV', description: '部署环境' ,choices: ['DEV','SIT', 'UAT', 'PET','REL','PRD']
		booleanParam name: 'DEPLOY_FRONTEND', description: '是否部署前端',defaultValue: true
		booleanParam name: 'DEPLOY_BACKEND', description: '是否部署后台',  defaultValue: false
		text name: 'DESCRIPTION',description: '请输入描述', defaultValue: 'XXXXXXXX需求（需求单号:1111-2222-3333-2222-1111）: \n 1.xxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n 2.xxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n 3.xxxxxxxxxxxxxxxxxxxxxxxxxxxxx \n\n开发负责人: XX  \n需求负责人: XX\n相关材料:http://confluence.nings.com/1111-2222-3333-2222-1111'
		//extendedChoice name: 'DEPLOY_ENV', description: '部署环境' ,choices: ['DEV','SIT', 'UAT', 'REL']
		//imageTag(name: 'DOCKER_IMAGE', description: '',image: 'base/svc', filter: '.*', defaultTag: '1.0',registry: 'http://harbor.nings.com', credentialId: 'xxxx-xxx-xxx-xxx-xxxx', tagOrder: 'NATURAL')
	}
	//定义变量
	environment {
		BUILD_USER_ID = ""
		BUILD_USER = ""
		BUILD_USER_EMAIL = ""
		AUTHOR=""
		TIME_NAME="apim"
		// 项目名称
        // PROJECT = ''
        // 工程名称
        // APP_NAME = ""
        // 发布环境
        // DEPLOY_ENV = "${params.发布环境}"
        // 仓库地址
        // GIT_REPO = "${params.GIT_REPO}"
        // 仓库分支
        // BRANCH = "${params.BRANCH}"
        // 备份路径
        // BAK_PATH = "backup/"
        // 模块路径
        // APP_PATH = ""
        //默认邮件接收人
        // DEFAULT_EMAIL = ''
        //负责邮件接收人
        //OWNER_EMAIL = ''
        //PL邮件接收人
        //PL_EMAIL = ' '
        //版本
        TAG = "`date '+%Y-%m-%d-%H'-${BUILD_NUMBER}`"
	}
	//步骤
	stages {
		stage('Authorized use') {
			steps {
			    echo '请确在2分钟内认授权！'
                timeout(time: 2, unit: 'HOURS') {
			        input message: 'Welcome to use the automated intelligent management, All rights reserved, please obtain Nings’s license before use,unlicensed, illegal reproduction, use and so on are strictly prohibited.Please authorize use!', ok: '授权', submitter: 'admin'
                }
			}
		}
		stage('Parameter checking') {
			steps{
				script{
					echo "debug info:描述 ${env.DESCRIPTION}"
					if(env.DESCRIPTION == null || env.DESCRIPTION == ""){
						echo "⭐构建失败:请输入描述DESCRIPTION(⊙﹏⊙)！"
						sh "exit 1"
					}


					wrap([$class: 'BuildUser']){
						AUTHOR = "${env.BUILD_USER_EMAIL} ${env.BUILD_USER} ${env.BUILD_TAG}"
					}
					echo "debug info: 构建用户 ${AUTHOR}"
					if(AUTHOR == null || AUTHOR == ""){
						echo "⭐构建失败:无法获取负责人AUTHOR信息(⊙﹏⊙)！"
						sh "exit 1"
					}

					VERSION_TAG=new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
					echo "debug info: 版本 ${VERSION_TAG}"
					if(VERSION_TAG == null || VERSION_TAG == ""){
						echo "⭐构建失败:请输入版本号Revision(⊙﹏⊙)！"
						sh "exit 1"
					}

					echo "debug info: DEPLOY_FRONTEND: ${env.DEPLOY_FRONTEND}  DEPLOY_BACKEND: ${env.DEPLOY_BACKEND} "
					if(env.DEPLOY_FRONTEND == "false" &&  env.DEPLOY_BACKEND ==  "false" ){
						echo "⭐构建失败:请选择构建项(⊙﹏⊙)！"
						sh "exit 1"
					}
					
				
					env.WORKSPACE=JENKINS_HOME+"/projects/"+env.TIME_NAME+"/"+env.DEPLOY_ENV
					echo "debug info: 构建workspace ${WORKSPACE}"

					env.RemoteCodeRepository=WORKSPACE+"/RemoteCodeRepository"
					echo "debug info: RemoteCodeRepository: ${RemoteCodeRepository}"
					
					env.GenDeployPackage=WORKSPACE+"/GenDeployPackage"
					echo "debug info: GenDeployPackage: ${GenDeployPackage}"

					env.BUILID_WORK_SPACE=GenDeployPackage+"/"+VERSION_TAG
					echo "debug info: BUILID_WORK_SPACE: ${BUILID_WORK_SPACE}"

					env.CURR_AUTO_DEPLOY_HOME=RemoteCodeRepository+"/AutoDeploy"
					env.CURR_ENV_FRONTEND_HOME=RemoteCodeRepository+"/frontend"
					env.CURR_ENV_BACKEND_HOME=RemoteCodeRepository+"/backend"


                    //def currCfgRemarks=["envType":env.DEPLOY_ENV,"Author":AUTHOR,"Revision":VERSION_TAG,"fileTime":false]
                    //println(currCfgRemarks.toString())
                    //println(currCfgRemarks.toMapString())

					//def currCfgRemarksJson = JsonOutput.toJson(currCfgRemarks)
					//println(currCfgRemarksJson)
					//println(JsonOutput.prettyPrint(currCfgRemarksJson))


					def slurper = new JsonSlurper()
					//def currCfgRemarks = slurper.parseText(currCfgRemarksJson)
					//println(currCfgRemarks)
					env.CfgRemarks=slurper.parseText(JsonOutput.toJson(["envType":env.DEPLOY_ENV,"Author":AUTHOR,"Revision":VERSION_TAG,"fileTime":false]))
					echo env.CfgRemarks
				}


			}
		}


		stage('buidl package') {
			steps {
				sh label: '', script: '''
					rm -rf ${GenDeployPackage}/*
					mkdir -p $CURR_AUTO_DEPLOY_HOME
					mkdir -p CURR_ENV_FRONTEND_HOME
					mkdir -p CURR_ENV_BACKEND_HOME
					mkdir -p ${BUILID_WORK_SPACE}
					ls ${WORKSPACE}
				'''
				script{
					if(env.DEPLOY_FRONTEND == "true" ){
						echo "debug info: WORK_SPACE ${env.WORK_SPACE}"
						echo "debug info: git frontend code"
						checkout scmGit(
							branches: [[name: "${DEPLOY_ENV}"]],
							extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: "${CURR_ENV_FRONTEND_HOME}"]],
							userRemoteConfigs: [[credentialsId: 'a922577c-0b17-4576-986d-dd27d40bba83', url: 'http://gitlab.nings.com/open/frontend.git']]
						)

						checkout scmGit(
							branches: [[name: '${DEPLOY_ENV}']],
							extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: "${CURR_ENV_NODE_CONFIGE}"]],
							userRemoteConfigs: [[credentialsId: 'a922577c-0b17-4576-986d-dd27d40bba83', url: 'http://gitlab.nings.com/open/autodeploy.git']]
						)

						def remote = [:]
						remote.name = 'appUser'
						remote.host = '10.211.55.42'
						remote.allowAnyHosts = true
						input id: 'SelectSvc', message: '', ok: '确认', parameters: [choice(choices: ['a', 'b', 'c', 'd', 'e'], description: '微服务服务列表', name: 'podname')], submitter: 'admin'
						withCredentials([usernamePassword(credentialsId: 'appUser', passwordVariable: 'password', usernameVariable: 'username')]) {
							remote.user = "${username}"
							remote.password = "${password}"
						}
						sh label: '', script: '''
						cp -r $CURR_ENV_NODE_HOME/* $CURR_ENV_NODE_CONFIGE/
						'''
						//sshCommand remote: remote, command: "node ${CURR_ENV_NODE_CONFIGE}/startNode/creApiRunPrdGrp.js common"
						//#test ! -f ${CURR_ENV_NODE_CONFIGE}/node_modules && tar -xvzf ${CURR_ENV_NODE_CONFIGE}/node_modules.tar.gz -C ${CURR_ENV_NODE_CONFIGE}/
						sshCommand remote: remote, command:"""

						    cd /data/nas/container/jenkins/node1/app/projects/apim/DEV/RemoteCodeRepository/api-node-config/ && node startNode/creApiRunPrdGrp.js common

						    """
					}

					echo "3 ${env.AUTHOR} ${AUTHOR}  ${VERSION_TAG}  ${env.Description}"
				}
			}
		}
		//next stage(){}
	}
}
