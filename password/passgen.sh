TENANT="mocana-eval"
EXT=".txt"
PASSWORD_DIR="/tmp/password"
PASSWORD_FILE="$PASSWORD_DIR/$TENANT$EXT"
AWS_REGION="us-east-1"
AWS_BUCKET="tenant-pw"
Policy_Name="OnlyGetS3Object"
Policy_File="file://policy"

# create IAM user with proper access privileges
is_user_exist=$(aws iam list-users | grep $TENANT)
is_policy_exist=$(aws iam list-attached-user-policies --user-name $TENANT | grep $Policy_Name)
is_bucket_exist=$(aws s3 ls 2>&1 | grep $AWS_BUCKET)

if [[ ! $is_user_exist ]]; then
  echo "creating new user $TENANT"
  aws iam create-user --user-name $TENANT
  if [[ ! $is_policy_exist ]]; then
    echo "no policy exists, creating S3 read only policy"
    aws iam create-policy --policy-name $Policy_Name --policy-document $Policy_File
  else
    echo "attaching the S3 read only policy"
    aws iam attach-user-policy --policy-arn arn:aws:iam::572901891375:policy/OnlyGetS3Object --user-name $TENANT
  fi
fi

# create password
password=$(pwgen -s 32 -1)
echo "password = $password"
mkdir -p $PASSWORD_DIR
touch $PASSWORD_FILE
echo $password > $PASSWORD_FILE
echo "password generated..."

# put into S3 bucket
if [[ ! $is_bucket_exist ]]; then
  echo "bucket exists"
else
  aws s3 mb "s3://${AWS_BUCKET}"
fi

aws s3 cp $PASSWORD_FILE "s3://${AWS_BUCKET}/${TENANT}${EXT}"
aws s3 ls "s3://${AWS_BUCKET}/"

rm -rf $PASSWORD_FILE