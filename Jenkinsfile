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
	
	/*
	triggers触发器
	支持cron、pollSCM、upstream三种方式
	cron('0 * * * *')定时执行就像cronjob一样，一到时间点就执行。Jenkins采用了UNIX任务调度工具CRON的配置方式，用5个字段代表5个不同的时间单位（中间用空格隔开）
	pollSCM定期到代码仓库轮询代码是否有变化，如果有变化就执行。pollSCM('H/1 * * * *')
	*/
	/*
	triggers{
		//pollSCM()
	}
	*/
	/*
	agent：用于指定执行job的节点
		必须存在，agent必须在pipeline块内的顶层定义
		any ：可以在任意agent 上执行pipeline
		none ：pipeline 将不分配全局agent，每个stage分配自己的agent
		label ：指定运行节点的label
		node：自定义运行节点配置，指定label ，指定customWorkspace(工作空间)
		docker：控制目标节点上的docker运行相关内容
	*/
	agent any
	//选项参数
	options {
		//pipeline保持构建的最大个数
		buildDiscarder(logRotator(numToKeepStr: '5'))
		//不允许并行执行Pipeline,可用于防止同时访问共享资源等
		disableConcurrentBuilds()
		//默认跳过来自源代码控制的代码
		skipDefaultCheckout()
		//一旦构建状态进入了“Unstable”状态，就跳过此stage
		skipStagesAfterUnstable()
		//设置Pipeline运行的超时时间
		timeout(time: 10, unit: 'HOURS')
		//失败后，重试整个Pipeline的次数
		retry(1)
		//在控制台打印所有操作的时间戳
		timestamps()
	 }
	//工具集Global Tool Configuration tools指令默认支持3种工具：JDK、Maven、Gradle。通过安装插件，tools 指令还可以支持更多的工具。
	/*
	tools{
		//openjdk 'openjdk17'
		//git 'Default'
		//maven 'MAVEN_HOME'
	}
	*/
	//定义构建参数
	parameters {
		booleanParam name: 'DEPLOY_CLOUD', description: '是否上云',  defaultValue: false
		choice name: 'DEPLOY_ENV', description: '部署环境' ,choices: ['DEV','SIT', 'UAT', 'PET','REL','PRD']
		booleanParam name: 'AUTO_TEST', description: '自动化测试',  defaultValue: true
		booleanParam name: 'SECURITY_SCAN', description: '自动化测试',  defaultValue: true
		booleanParam name: 'DEPLOY_FRONTEND', description: '是否部署前端',defaultValue: true
		booleanParam name: 'DEPLOY_BACKEND', description: '是否部署后台',  defaultValue: false
		text name: 'DESCRIPTION',description: '请输入描述', defaultValue: '【需求编号】：1111-2222-3333-2222-1111 XXXXXXXX需求\n【变更原因】：新增xxxxxxxxxxxxxxxxxxxxxxxxxxxxx接口\n【变更内容】：新增xxxxx接口\n【负 责 人】：开发: XXX 测试：XXX\n【相关材料】: http://confluence.nings.com/1111-2222-3333-2222-1111'
		//extendedChoice name: 'DEPLOY_ENV', description: '部署环境' ,choices: ['DEV','SIT', 'UAT', 'REL']
		//imageTag(name: 'DOCKER_IMAGE', description: '',image: 'base/svc', filter: '.*', defaultTag: '1.0',registry: 'http://harbor.nings.com', credentialId: 'xxxx-xxx-xxx-xxx-xxxx', tagOrder: 'NATURAL')
        booleanParam name: 'IS_OPEN_DEBUG', description: '是否开始DEBUG模式',  defaultValue: false
	}
	//定义变量
	environment {
		BUILD_USER_ID = ""
		BUILD_USER = ""
		BUILD_USER_EMAIL = ""
		AUTHOR=""
		TIME_NAME="devops"
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
		DEPLOY_TAG = "`date '+%Y-%m-%d-%H'-${BUILD_NUMBER}`"
		//代码路径echo "*.*.*.* github.com" >> /etc/hosts
		CODE_REOTE_URL="https://github.com/AlwaysOnlineSuperMan"
		SSH_REMOTE_HOST="10.211.55.41"
		K8S_REMOTE_HOST="10.211.55.41"
		//ExamineAndVerify="不同意"

		//邮件通知配置
		EMAIL_TO="1150550809@qq.com"
		EMAIL_FROM="1150550809@qq.com"
		//"DevOps Administrator<admin@devops.com>"
		OPEN_DEBUG=false
	}
	/*
	阶段集：必须存在，用与设定具体的stage，包含顺序执行的一个或者多个stage命令，在pipeline内仅能使用一次，需要定义stage的名字
	*/
	stages {
		//阶段: 比如 Build（构建）、测试（Test）、部署（Deploy）阶段
		stage('Authorized use') {
			//步骤：必须存在，steps位于stage指令块内部，包含一个或者多个step
			steps {
				script{
			   
			    env.OPEN_DEBUG=env.IS_OPEN_DEBUG
				env.VERSION_TAG=new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+"${env.BUILD_NUMBER}"
				echo '请确在2分钟内认授权！'
				timeout(time: 2, unit: 'MINUTES') {
					emailext body: '${ENV,var="JOB_NAME"}正在执行第${ENV,var="BUILD_ID"}次构建，<A href="${ENV,var="JENKINS_URL"}blue/organizations/jenkins/${ENV,var="JOB_NAME"}/detail/${ENV,var="JOB_NAME"}/${ENV,var="BUILD_ID"}/pipeline"}">请在2分钟内授权</A>', subject: "DevOpsVerify:${env.JOB_NAME}-Build#${env.BUILD_NUMBER}", to: "${EMAIL_TO}",from: "${EMAIL_FROM}"
					env.ExamineAndVerify =input message: 'Welcome to use the automated intelligent management, All rights reserved, please obtain Nings’s license before use,unlicensed, illegal reproduction, use and so on are strictly prohibited.Please authorize use!', ok: '授权', parameters: [text(defaultValue: '同意构建部署',description: '审核意见（非必输）', name: 'ExamineAndVerify')], submitter: 'admin'
					//input message: 'Welcome to use the automated intelligent management, All rights reserved, please obtain Nings’s license before use,unlicensed, illegal reproduction, use and so on are strictly prohibited.Please authorize use!', ok: '授权', submitter: 'admin'
					 if(env.OPEN_DEBUG=="true") echo "debug info: 审核意见 ${env.ExamineAndVerify}"
					 if(env.OPEN_DEBUG=="true") sh "echo info:环境参数 && printenv"
				}
				
				}
			}
		}
		stage('Parameter checking') {
			steps{
				script{
					if(env.OPEN_DEBUG=="true") echo "debug info: 版本 ${VERSION_TAG}"
					if(VERSION_TAG == null || VERSION_TAG == ""){
						echo "⭐构建失败:请输入版本号Revision(⊙﹏⊙)！"
						sh "exit 1"
					}
					if(env.OPEN_DEBUG=="true") echo "debug info:描述 ${env.DESCRIPTION}"
					if(env.DESCRIPTION == null || env.DESCRIPTION == ""){
						echo "⭐构建失败:请输入描述DESCRIPTION(⊙﹏⊙)！"
						sh "exit 1"
					}


					wrap([$class: 'BuildUser']){
						AUTHOR = "${env.BUILD_USER_EMAIL} ${env.BUILD_USER} ${env.BUILD_TAG}"
					}
					if(env.OPEN_DEBUG=="true") echo "debug info: 构建用户 ${AUTHOR}"
					if(AUTHOR == null || AUTHOR == ""){
						echo "⭐构建失败:无法获取负责人AUTHOR信息(⊙﹏⊙)！"
						sh "exit 1"
					}

					
				   

					if(env.OPEN_DEBUG=="true") echo "debug info: DEPLOY_FRONTEND: ${env.DEPLOY_FRONTEND}  DEPLOY_BACKEND: ${env.DEPLOY_BACKEND} "
					if(env.DEPLOY_FRONTEND == "false" &&  env.DEPLOY_BACKEND ==  "false" ){
						echo "⭐构建失败:请选择构建项(⊙﹏⊙)！"
						sh "exit 1"
					}


					env.WORKSPACE=JENKINS_HOME+"/projects/"+env.TIME_NAME+"/"+env.DEPLOY_ENV
					if(env.OPEN_DEBUG=="true") echo "debug info: 构建workspace ${WORKSPACE}"

					env.RemoteCodeRepository=WORKSPACE+"/RemoteCodeRepository"
					if(env.OPEN_DEBUG=="true") echo "debug info: RemoteCodeRepository: ${RemoteCodeRepository}"

					env.GenDeployPackage=WORKSPACE+"/GenDeployPackage"
					if(env.OPEN_DEBUG=="true") echo "debug info: GenDeployPackage: ${GenDeployPackage}"

					env.BUILID_WORK_SPACE=GenDeployPackage+"/"+VERSION_TAG
					if(env.OPEN_DEBUG=="true") echo "debug info: BUILID_WORK_SPACE: ${BUILID_WORK_SPACE}"

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
					if(env.OPEN_DEBUG=="true") echo env.CfgRemarks
				}


			}
		}


		stage('buidl package') {
			steps {
				//本地执行
				sh label: '', script: '''
					rm -rf ${GenDeployPackage}/*
					mkdir -p $CURR_AUTO_DEPLOY_HOME
					mkdir -p CURR_ENV_FRONTEND_HOME
					mkdir -p CURR_ENV_BACKEND_HOME
					mkdir -p ${BUILID_WORK_SPACE}
					ls ${WORKSPACE}
					rm -rf $CURR_ENV_FRONTEND_HOME
				'''
				script{
					if(env.DEPLOY_FRONTEND == "true" ){
						if(env.OPEN_DEBUG=="true") echo "debug info: git frontend code ${CODE_REOTE_URL}/backend.git ${CURR_ENV_FRONTEND_HOME}"
						//拉取代码
						checkout scmGit(
							branches: [[name: "${DEPLOY_ENV}"]],
							extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: "${CURR_ENV_FRONTEND_HOME}"]],
							userRemoteConfigs: [[credentialsId: 'AlwaysOnlineSuperMan', url: "${CODE_REOTE_URL}/frontend.git"]]
						)
						//credentialsId-github-nings/AlwaysOnlineSuperMan/AlwaysOnline
						//输入选择
						//input id: 'SelectSvc', message: '', ok: '确认', parameters: [choice(choices: ['a', 'b', 'c', 'd', 'e'], description: '微服务服务列表', name: 'podname')], submitter: 'admin'
						
						//sh label: '', script: '''
						//	test -d ${CURR_ENV_FRONTEND_HOME}/node_modules && ls ${CURR_ENV_FRONTEND_HOME}
						//'''
						
						//远程SSH执行
						def deploy_k8s_remote = [:]
						deploy_k8s_remote.name = 'appUser'
						deploy_k8s_remote.host = "${K8S_REMOTE_HOST}"
						deploy_k8s_remote.allowAnyHosts = true
						withCredentials([usernamePassword(credentialsId: 'SSH-K8S-USER', passwordVariable: 'password', usernameVariable: 'username')]) {
							deploy_k8s_remote.user = "${username}"
							deploy_k8s_remote.password = "${password}"
						}
						//kubectl get all -A
						sshCommand remote: deploy_k8s_remote, command:"""
							hostname -i
						"""
						
					}
					if(env.DEPLOY_BACKEND == "true" ){
						if(env.OPEN_DEBUG=="true") echo "debug info: git backend code ${CODE_REOTE_URL}/backend.git ${CURR_ENV_FRONTEND_HOME}"
						//拉取代码
						checkout scmGit(
							branches: [[name: "${DEPLOY_ENV}"]],
							extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: "${CURR_ENV_FRONTEND_HOME}"]],
							userRemoteConfigs: [[credentialsId: 'AlwaysOnlineSuperMan', url: "${CODE_REOTE_URL}/backend.git"]]
						)
					}

					if(env.OPEN_DEBUG=="true") echo "debug info: ${env.AUTHOR} ${AUTHOR}  ${VERSION_TAG}  ${env.DESCRIPTION}"
				}
			}
		}
		//next stage()
	}
	/*
	根据执行记的结果决定处理内容，就像Java程序中catch块中做的那样，post{}根据pipeline或者stage的执行结果预先定义了多个条件，通过在流水线中声明这些条件和在这些条件之下的steps操作即可，类似回调函数的使用方法，你也可以把它看作是try…catch…的封装实现，从而使得对于异常的处理更加方便。
	使用限制：需要写在pipeline或者stage块中
	可选vs必选：可选
	支持的条件预置：
	always: 无论pipeline或者stage的执行结果如何，此块中的预置操作都会执行。
	changed：只有当pipeline或者stage的执行后，当前状态与之前发生了改变时，此块中的预置操作才会执行。
	fixed：前一次运行为不稳定状态或者失败状态，而且本次运行成功结束，这两个条件同时满足时，此块中的预置操作才会执行。
	regression： 本次运行状态为不稳定状态，失败状态或者是中止状态，而且前一次运行成功结束，这两个条件同时满足时，此块中的预置操作才会执行。
	aborted：当前pipeline或者stage的状态为aborted时，此块中的预置操作才会执行。通常是由于流水线被手工中会导致此状态产生，而产生此状态后，通常在Jenkins的UI界面会显示为灰色。
	failure：当前pipeline或者stage的状态为failed时，此块中的预置操作才会执行。而产生此状态后，通常在Jenkins的UI界面会显示为红色。
	success：当前pipeline或者stage的状态为success时，此块中的预置操作才会执行。而产生此状态后，通常在Jenkins的UI界面会显示为绿色。
	unstable： 当前pipeline或者stage的状态为unstable时，此块中的预置操作才会执行。通常情况下测试失败或者代码规约的违反都会导致此状态产生，而产生此状态后，通常在Jenkins的UI界面会显示为黄色。
	unsuccessful：当前pipeline或者stage的状态不是success时，此块中的预置操作才会执行。
	cleanup：无论pipeline或者stage的状态为何种状态，在post中的其他的条件预置操作执行之后，此块中的预置操作就会执行。
	注意： cleanup和always的区别在于，cleanup会在其他任意一个条件预置操作执行之后就会执行。
	*/
	 post {
		always {
			/*
			邮件推送
			<li>构建项目：${PROJECT_NAME}</li>
			<li>构建结果：<span style="color:red">${BUILD_STATUS} </span></li>
			<li>构建编号：${BUILD_NUMBER}</li>
			<li>触发用户：${CAUSE}</li>
			<li>变更概要：${CHANGES}</li>
			<li>构建地址：<a href= >${BUILD_URL}</a ></li>
			<li>构建日志：<a href=${BUILD_URL}console>${BUILD_URL}console</a ></li>
			<li>报告地址：<a href=${BUILD_URL}allure>${BUILD_URL}allure</a ></li>
			<li>变更集：${JELLY_SCRIPT}</li>
			*/
			emailext (
				subject: "DevOpsBulid:${env.JOB_NAME}-Build#${env.BUILD_NUMBER}",
				body:  '''<style>
						  BODY, TABLE, TD, TH, P {
							font-family: Calibri, Verdana, Helvetica, sans serif;
							font-size: 12px;
							color: black;
						  }
						  .console {
							font-family: Courier New;
						  }
						  .filesChanged {
							width: 10%;
							padding-left: 10px;
						  }
						  .section {
							width: 100%;
							border: thin black dotted;
						  }
						  .td-title-main {
							color: white;
							font-size: 200%;
							padding-left: 5px;
							font-weight: bold;
						  }
						  .td-title {
							color: white;
							font-size: 120%;
							font-weight: bold;
							padding-left: 5px;
							text-transform: uppercase;
						  }
						  .td-title-tests {
							font-weight: bold;
							font-size: 120%;
						  }
						  .td-header-maven-module {
							font-weight: bold;
							font-size: 120%;    
						  }
						  .td-maven-artifact {
							padding-left: 5px;
						  }
						  .tr-title {
							background-color: #E74C3C;
						  }
						  .test {
							padding-left: 20px;
						  }
						  .test-fixed {
							color: #27AE60;
						  }
						  .test-failed {
							color: #E74C3C;
						  }
						</style>
						 <!-- MODE SETTINGS-->
						  <table class="section">
							<tr class="tr-title">
							  <td class="td-title-main" colspan="2">
								部署模块
							  </td>
							</tr>
							<tr>
							  <td>是否上云CLOUD:</td>
							  <td>${DEPLOY_CLOUD}</td>
							</tr>
							<tr>
							  <td>部署环境:</td>
							  <td>${DEPLOY_ENV}</td>
							</tr>
				 
							<tr>
							  <td>版本号:</td>
							  <td>${ENV, var="VERSION_TAG"}</td>
							</tr>
							 <tr>
							  <td>审核意见:</td>
							  <td>${ENV, var="ExamineAndVerify"}</td>
							</tr>
							<tr>
							  <td>前端FRONTEND是否部署:</td>
							  <td>${DEPLOY_FRONTEND}</td>
							</tr>
							<tr>
							  <td>后台BACKEND是否部署:</td>
							  <td>${DEPLOY_BACKEND}</td>
							</tr>
							
							<tr>
							  <td>描述:</td>
							  <td>${Description}></td>
							</tr>
						  </table>
						  <br>
						${SCRIPT,template="groovy-html.template"}
						'''
				,
				recipientProviders:[[$class:'DevelopersRecipientProvider']],
				to: "${EMAIL_TO}",
				from: "${EMAIL_FROM}"
			)
		}
		
		unstable {
		   echo "post condition executed: unstable ..."
		}
		unsuccessful {
		   echo "post condition executed: unsuccessful ..."
		}
		cleanup {
		   echo "post condition executed: cleanup ..."
		}
	 }
}
