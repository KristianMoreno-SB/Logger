##!/cygdrive/c/cygwin/bin/bash
#!/bin/bash

#*** PARAMETERS ***
#	$1 = VERSION_NUMBER x.x.x (ex 1.0.5)
#		This will be used to generate the release folder etc
#		OLD: #read -p "New Version Number x.x.x ?" VERSION_NUMBER

VERSION_NUMBER=$1
SQL_CONNECTION=$2
INCLUDE_RELEASE_FOLDER=$3

{
if [ -z "${VERSION_NUMBER}" ]; then
  echo "VERSION_NUMBER (parameter 1) is not defined"
  exit 0
fi
#if [ -z "${SQL_CONNECTION}" ]; then
#	echo "SQL_CONNECTION (parameter 2) is not defined"
#	exit 0
#fi

#91: Allow option to include release folder or not. Useful for developers, but should be excluded by default
#Upper value
INCLUDE_RELEASE_FOLDER=$(echo $INCLUDE_RELEASE_FOLDER | awk '{print toupper($0)}')
if [ "$INCLUDE_RELEASE_FOLDER" = "" ]; then
	INCLUDE_RELEASE_FOLDER=N
fi
echo "INCLUDE_RELEASE_FOLDER: $INCLUDE_RELEASE_FOLDER"
}

echo "Building release $VERSION_NUMBER"


#Generate no_op code
START_DIR="$PWD"
#cd ../source/packages
#sqlplus $SQL_CONNECTION @../gen_no_op.sql
cd $START_DIR


#*** VARIABLES ***
RELEASE_FOLDER=../releases/$VERSION_NUMBER
INSTALL=$RELEASE_FOLDER/"loggerr_install.sql"
NO_OP=$RELEASE_FOLDER/"loggerr_no_op.sql"


#Clear release folder (if it exists) and make directory
rm -rf ../releases/$VERSION_NUMBER
mkdir ../releases/$VERSION_NUMBER


#Build files

#rm -f ../build/loggerr_install.sql
#rm -f ../build/loggerr_latest.zip
#rm -f ../build/loggerr_no_op.sql

#PREINSTALL
cat ../source/install/loggerr_install_prereqs.sql > $INSTALL
printf '\n' >> $INSTALL

#NO OP Code
printf "\x2d\x2d This file installs a NO-OP version of the logger package that has all of the same procedures and functions,\n" > $NO_OP
printf "\x2d\x2d but does not actually write to any tables. Additionally, it has no other object dependencies.\n" >> $NO_OP
printf "\x2d\x2d You can review the documentation at https://github.com/OraOpenSource/Logger for more information.\n" >> $NO_OP
printf '\n' >> $NO_OP
#Seeting compilation flag so that tables are just skeletons (no triggers, sequences, etc)
printf "alter session set plsql_ccflags='loggerr_no_op_install:true' \n/ \n\n\n" >> $NO_OP



#78: Need to build tables for no_op to reference
#TABLES - Output for both regular and NO_OP
printf 'PROMPT tables/loggerr_logs.sql \n' | tee -a $INSTALL $NO_OP > /dev/null
cat ../source/tables/loggerr_logs.sql | tee -a $INSTALL $NO_OP > /dev/null
printf '\n' | tee -a $INSTALL $NO_OP > /dev/null
printf 'PROMPT tables/loggerr_prefs.sql \n' | tee -a $INSTALL $NO_OP > /dev/null
cat ../source/tables/loggerr_prefs.sql | tee -a $INSTALL $NO_OP > /dev/null
printf '\n' | tee -a $INSTALL $NO_OP > /dev/null
printf 'PROMPT tables/loggerr_logs_apex_items.sql \n' | tee -a $INSTALL $NO_OP > /dev/null
cat ../source/tables/loggerr_logs_apex_items.sql | tee -a $INSTALL $NO_OP > /dev/null
printf '\n' | tee -a $INSTALL $NO_OP > /dev/null
printf 'PROMPT tables/loggerr_prefs_by_client_id.sql \n' | tee -a $INSTALL $NO_OP > /dev/null
cat ../source/tables/loggerr_prefs_by_client_id.sql | tee -a $INSTALL $NO_OP > /dev/null
printf '\n' | tee -a $INSTALL $NO_OP > /dev/null

#JOBS
printf 'PROMPT jobs/loggerr_purge_job.sql \n' >> $INSTALL
cat ../source/jobs/loggerr_purge_job.sql >> $INSTALL
printf '\n' >> $INSTALL
printf 'PROMPT jobs/loggerr_unset_prefs_by_client.sql \n' >> $INSTALL
cat ../source/jobs/loggerr_unset_prefs_by_client.sql >> $INSTALL
printf '\n' >> $INSTALL

#VIEWS - Output for both regular and NO_OP
printf 'PROMPT views/loggerr_logs_5_min.sql \n' | tee -a $INSTALL $NO_OP > /dev/null
cat ../source/views/loggerr_logs_5_min.sql | tee -a $INSTALL $NO_OP > /dev/null
printf '\n' | tee -a $INSTALL $NO_OP > /dev/null
printf 'PROMPT views/loggerr_logs_60_min.sql \n' | tee -a $INSTALL $NO_OP > /dev/null
cat ../source/views/loggerr_logs_60_min.sql | tee -a $INSTALL $NO_OP > /dev/null
printf '\n' | tee -a $INSTALL $NO_OP > /dev/null
printf 'PROMPT views/loggerr_logs_terse.sql\n' | tee -a $INSTALL $NO_OP > /dev/null
cat ../source/views/loggerr_logs_terse.sql | tee -a $INSTALL $NO_OP > /dev/null
printf '\n' | tee -a $INSTALL $NO_OP > /dev/null

#PACKAGES
printf 'PROMPT packages/loggerr.pks \n' >> $INSTALL
cat ../source/packages/loggerr.pks >> $INSTALL
printf '\n' >> $INSTALL
printf 'PROMPT packages/loggerr.pkb \n' >> $INSTALL
cat ../source/packages/loggerr.pkb >> $INSTALL
printf '\n' >> $INSTALL


#Recompile loggerr_prefs trigger as it has dependencies on loggerr.pks
printf 'PROMPT Recompile biu_loggerr_prefs after loggerr.pkb \n' >> $INSTALL
printf '\nalter trigger biu_loggerr_prefs compile;\n' | tee -a $INSTALL $NO_OP > /dev/null

#CONTEXTS
printf 'PROMPT contexts/loggerr_context.sql \n' >> $INSTALL
cat ../source/contexts/loggerr_context.sql >> $INSTALL
printf '\n' >> $INSTALL

#PROCEDURES
printf 'PROMPT procedures/loggerr_configure.plb \n' >> $INSTALL
cat ../source/procedures/loggerr_configure.plb >> $INSTALL
printf '\n' >> $INSTALL


#Post install
printf 'PROMPT install/post_install_configuration.sql \n' >> $INSTALL
cat ../source/install/post_install_configuration.sql >> $INSTALL
printf '\n' >> $INSTALL



#NO OP Code
printf '\n\nprompt *** loggerr.pks *** \n\n' >> $NO_OP
cat ../source/packages/loggerr.pks >> $NO_OP
printf '\n\nprompt *** loggerr.pkb *** \n\n' >> $NO_OP
cat ../source/packages/loggerr_no_op.pkb >> $NO_OP
printf '\n\nprompt\n' >> $NO_OP
printf 'prompt *************************************************\n' >> $NO_OP
printf 'prompt Now executing LOGGERR.STATUS...\n' >> $NO_OP
printf 'prompt ' >> $NO_OP
printf '\nbegin \n\tloggerr.status; \nend;\n/\n\n' >> $NO_OP
printf 'prompt *************************************************\n' >> $NO_OP
printf '\n\n' >> $NO_OP



#Recompile loggerr_logs_terse since it depends on logger
printf '\nalter view loggerr_logs_terse compile;\n' | tee -a $INSTALL $NO_OP > /dev/null

#Copy "other" scripts
cp -f ../source/install/create_user.sql $RELEASE_FOLDER
cp -f ../source/install/drop_loggerr.sql $RELEASE_FOLDER

#Copy Scripts
cp -r ../source/scripts $RELEASE_FOLDER

#Copy main package file for developers to easily review
cp -f ../source/packages/loggerr.* $RELEASE_FOLDER

#Copy README
cp -f ../README.md $RELEASE_FOLDER

#Copy demo scripts
cp -fr ../demos $RELEASE_FOLDER

#Copy docs #89
cp -fr ../docs $RELEASE_FOLDER

#Copy License
cp -f ../LICENSE $RELEASE_FOLDER


chmod 777 $RELEASE_FOLDER/*.*


#Replace any references for the version number
sed -i.del "s/x\.x\.x/$VERSION_NUMBER/g" $RELEASE_FOLDER/loggerr_install.sql
sed -i.del "s/x\.x\.x/$VERSION_NUMBER/g" $RELEASE_FOLDER/loggerr.pks
#need to remove the backup file required for sed call
rm -rf $RELEASE_FOLDER/*.del



#Old windows zip7za a -tzip $/loggerr_$VERSION_NUMBER.zip ../build/*.sql ../build/*.html
#By CDing into the release_folder we don't get the full path in the zip file
cd $RELEASE_FOLDER
zip -r loggerr_$VERSION_NUMBER.zip .

#91: Copy zip to release root
cp -f loggerr_$VERSION_NUMBER.zip ../.

#Remove release folder if appliable
if [ "$INCLUDE_RELEASE_FOLDER" != "Y" ]; then
  echo Removing release folder
  cd $START_DIR
  rm -rf $RELEASE_FOLDER
else
  echo Keeping release folder
fi
