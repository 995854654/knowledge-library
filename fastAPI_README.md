# fastAPI

参考官方文档：`https://fastapi.tiangolo.com/zh/`

参考代码：[Github - yami-api](https://github.com/995854654/yami-api)



## learning



### 安全机制

以下代码是实现简单的登录校验

```python
from fastapi import APIRouter,Depends,HTTPException,status
from fastapi.security import OAuth2PasswordBearer,OAuth2PasswordRequestForm
from pydantic import BaseModel
from typing import Union
from utils.logger import LoguruLogger

security_router = APIRouter(
    tags=["security"],
    include_in_schema=True
)

fake_users_db = {
    "johndoe": {
        "username": "johndoe",
        "full_name": "John Doe",
        "email": "johndoe@example.com",
        "hashed_password": "fakehashedsecret",
        "disabled": False,
    },
    "alice": {
        "username": "alice",
        "full_name": "Alice Wonderson",
        "email": "alice@example.com",
        "hashed_password": "fakehashedsecret2",
        "disabled": True,
    },
}


# 对密码加密
def fake_hash_password(password: str):
    return "fakehashed" + password


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


class User(BaseModel):
    username: str
    email: Union[str, None] = None
    full_name: Union[str, None] = None
    disabled: Union[bool, None] = None


class UserInDB(User):
    hashed_password: str


def get_user(db: dict, username: str):
    if username in db:
        user_dict = db[username]
        return UserInDB(**user_dict)

def fake_decode_token(token):
    # This doesn't provide any security at all
    # Check the next version
    user = get_user(fake_users_db, token)
    return user

async def get_current_user(token: str = Depends(oauth2_scheme)):
    logger = LoguruLogger.get_logger()
    logger.info("get_current_user:" + token)
    user = fake_decode_token(token)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user

async def get_current_active_user(current_user: User = Depends(get_current_user)):
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user

@security_router.post("/token")
async def login(form_data:OAuth2PasswordRequestForm = Depends()):
    user_dict = fake_users_db.get(form_data.username)
    if not user_dict:
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    user = UserInDB(**user_dict)
    hashed_password = fake_hash_password(form_data.password)
    if not hashed_password == user.hashed_password:
        raise HTTPException(status_code=400, detail="Incorrect username or password")

    return {"access_token": user.username, "token_type": "bearer"}


@security_router.get("/security")
async def read_users_me(current_user: User = Depends(get_current_active_user)):
    return current_user

```



结合jwt与密码hash

```python
from jose import JWTError, jwt
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
from pydantic import BaseModel
from typing import Union
from datetime import datetime, timedelta, timezone
from utils.logger import LoguruLogger

security_router = APIRouter(
    tags=["security"],
    include_in_schema=True
)

SECRET_KEY = "3aa8e412cedeefe2cab00538284c10e8fc4edee454a9c0a3a5ab072bdef5f309"
ALGORITHM = "HS256"  # 算法
ACCESS_TOKEN_EXPIRE_MINUTES = 30  # 过期时间，30min后过期

fake_users_db = {
    "johndoe": {
        "username": "johndoe",
        "full_name": "John Doe",
        "email": "johndoe@example.com",
        # 这里有多个密码都是可以验证通过的，原因是因为passlib使用了salt随机生成的一个密文。
        # "hashed_password": "$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW",
        "hashed_password": "$2b$12$revuRgGRZ3z5KI0mR6D5KO3n7sauh6aXqS2mMa85AgvQ2ILS020lm",
        "disabled": False,
    }
}


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Union[str, None] = None


class User(BaseModel):
    username: str
    email: Union[str, None] = None
    full_name: Union[str, None] = None
    disabled: Union[bool, None] = None


class UserInDB(User):
    hashed_password: str


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


# 校验密码
def verify_password(plain_password, hashed_password):
    """

    :param plain_password: 用户输入的未加密密码
    :param hashed_password:
    :return:
    """
    return pwd_context.verify(plain_password, hashed_password)


# 密码加密
def get_password_hash(password):
    return pwd_context.hash(password)


def get_user(db, username: str):
    if username in db:
        user_dict = db[username]
        return UserInDB(**user_dict)


def authenticate_user(fake_db, username: str, password: str):
    user = get_user(fake_db, username)
    if not user:
        return False
    if not verify_password(password, user.hashed_password):
        return False
    return user


def create_access_token(data: dict, expires_delta: Union[timedelta, None] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)

    to_encode.update({"exp": expire})

    encode_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encode_jwt


def get_current_user(token: str = Depends(oauth2_scheme)):
    credential_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"}
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credential_exception
        token_data = TokenData(username=username)
    except JWTError:
        raise credential_exception
    user = get_user(fake_users_db, username=token_data.username)
    if user is None:
        raise credential_exception
    return user


def get_current_active_user(current_user: User = Depends(get_current_user)):
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user


@security_router.post("/token")
def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()) -> Token:
    user = authenticate_user(fake_users_db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"}
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": user.username}, expires_delta=access_token_expires)
    return Token(access_token=access_token, token_type="bearer")


@security_router.get("/users/me", response_model=User)
def read_users_me(current_user: User = Depends(get_current_active_user)):
    return current_user


@security_router.get("/users/me/items")
def read_own_items(current_user: User = Depends(get_current_active_user)):
    return [{"item_id": "Foo", "owner": current_user.username}]


if __name__ == '__main__':
    # "hashed_password": "$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW",
    # "hashed_password": "$2b$12$revuRgGRZ3z5KI0mR6D5KO3n7sauh6aXqS2mMa85AgvQ2ILS020lm",
    pwd1 = "$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW"
    pwd2 = "$2b$12$revuRgGRZ3z5KI0mR6D5KO3n7sauh6aXqS2mMa85AgvQ2ILS020lm"
    pwd = get_password_hash("secret")
    print(pwd)
    print(verify_password("secret", pwd2))

```



### 上传大文件

普通上传文件

NOTE:一定要使用async

```python
@upload_router.post("/upload_file")
async def upload_file(blob: UploadFile):
    service = get_storage_service()
    file_save_path = str(Path(str(service.get_path()) + "/" + blob.filename))
    with open(file_save_path, "ab") as buffer:
        while True:
            chunk = await blob.read(1024)  # 每次1024字节读取
            if not chunk:
                break
            buffer.write(chunk)

    return ResMsg(msg="上传成功！！")
```

请求并发处理

当涉及到大文件上传时，高并发处理能力是必不可少的。FastAPI天生支持异步处理，这意味着它可以同时处理多个请求，从而提高了处理速度。

为了充分利用FastAPI的异步处理能力，我们可以使用异步文件读取器（asynchronous file reader）

使用了`aiofiles`库来读写文件。通过使用异步I/O操作，我们可以同时处理多个请求，提高了上传大文件的效率。

```python

async def save_file(blob: UploadFile, file_path):
    async with aiofiles.open(file_path, "ab") as buffer:
        while True:
            chunk = await blob.read(1024)
            if not chunk:
                break
            await buffer.write(chunk)


@upload_router.post("/upload_file")
async def upload_file(blob: UploadFile):
    service = get_storage_service()
    file_save_path = str(Path(str(service.get_path()) + "/" + blob.filename))
    await save_file(blob, file_save_path)
    return ResMsg(msg="上传成功！！")

```



## 其他第三方包

### python-package -- enum

枚举类

**NOTE:** 如果枚举对象不加数据类型，则枚举的值会不相等

```python
from enum import Enum

class HttpStatus(int, Enum):
    NOT_FUND = 404
    FORBIDDEN = 403
    SUCCESS = 200
    FAIL = -1
    SERVER_ERROR = 500

print(404 == HttpStatus.NOT_FUND)  # True

# =====================================================
class HttpStatus(Enum):
    NOT_FUND = 404
    FORBIDDEN = 403
    SUCCESS = 200
    FAIL = -1
    SERVER_ERROR = 500

print(404 == HttpStatus.NOT_FUND)  # False
    
```





### python-package -- errno

1.  errno.EPERM：操作不允许
2.  errno.ENOENT：文件或目录不存在
3.  errno.EIO：输入/输出错误
4.  errno.ENXIO：设备不存在
5.  errno.EAGAIN：资源暂时不可用
6.  errno.ENOMEM：内存不足
7.  errno.EACCES：权限不足
8.  errno.EEXIST：文件已存在
9.  errno.ENOTDIR：不是一个目录
10.  errno.EISDIR：是一个目录
11.  errno.EINVAL：无效参数
12.  errno.ENOSPC：空间不足
13.  errno.ETIMEDOUT：操作超时
14.  errno.ECONNRESET：连接被对方重置
15.  errno.ECONNREFUSED：连接被拒绝

```python
import errno
raise FileNotFoundError(errno.ENOENT, os.strerror(errno.ENOENT), config_path)
# FileNotFoundError: [Errno 2] No such file or directory: 'E:\\git_project\\yami-api\\config1\\application.yml'
```



### third-party package -- pyyaml

作用：读取yml配置文件

**NOTE:** `yaml.load()`和`yaml.safe_load()`的区别

>   load可以加载python的基本数据类型外，还可以读取python对象和可执行代码，不安全
>
>   safe_load只可以读取python的基本数据类型，比如字典，列表，字符串等。优先选择这个函数

```python
```





### third-party package -- sqlalchemy

基本使用



>   **NOTE:**这里使用的是yield，而不是return，有一个延迟加载的效果，提升性能和节省资源

```python
#Model
from sqlalchemy.orm import sessionmaker
def get_db():
    settings: Settings = get_init_settings()
    _session = sessionmaker(bind=settings.metastore)
    session = _session()
    try:
        yield session
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        
db = get_db()
db.query()
```

NOTE: SQLite需要加上`connect_args={"check_same_thread": False}`

```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URL = "sqlite:///./sql_app.db"
# SQLALCHEMY_DATABASE_URL = "postgresql://user:password@postgresserver/db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
```



### third-party package -- loguru



使用Loguru支持异步写入，并且保证日志的完整性

下载:`pip install loguru`



logging.json配置

```json
{
  "logger": {
    "path": "/tmp/logs",
    "filename": "access.log",
    "level": "DEBUG",
    "rotation": "1 days",
    "retention": "1 months",
    "format": "<level>{level: <8}</level><green>{time:YYYY-MM-DD HH-mm-ss.SSS}</green> request id:{extra[request_id]} - <cyan>{name}</cyan><cyan>{function}</cyan><cyan>|</cyan><cyan>{line}</cyan> - <level>{message}</level>"
  }
}
```

相关解释

```txt
cyan:青色
green:绿色

< 左对齐
> 右对齐
^ 居中对齐

logging配置的format相关解释
<level>{level: <8}</level>  # 日志等级，左对齐，补充8个格子
<green>{time:YYYY-MM-DD HH-mm-ss.SSS}</green>  # 以绿色文字表示时间
{process.name}  # 进程名
{thread.name}  # 线程名
<cyan>{name}</cyan><cyan>{function}</cyan>  # 模块名.方法名
<cyan>{line}</cyan>   # 行
{extra[request_id]}  # logger需要通过logger.bind(request_id=request_id)绑定额外的参数
<level>{message}</level>  # 日志内容
```



自定义封装日志模块

>   **NOTE:** 因为fastAPI与loguru使用了两套日志，维护成本大，因此通过InterceptHandler等配置将fastAPI的日志绑定到loguru

```python
import logging
from pathlib import Path
import json
from loguru import logger
from utils.common import SingletonMeta
import sys

class InterceptHandler(logging.Handler):
    def __init__(self,request_id):
        super().__init__()
        self.request_id = request_id

    def emit(self, record: logging.LogRecord) -> None:
        try:
            level = logger.level(record.levelname).name
        except AttributeError:
            level = str(record.levelno)

        frame, depth = logging.currentframe(), 2
        while frame.f_code.co_filename == logging.__file__:
            frame = frame.f_back
            depth += 1
        log = logger.bind(request_id=self.request_id)
        log.opt(
            depth=depth,
            exception=record.exc_info
        ).log(level, record.getMessage())

class LoguruLogger(metaclass=SingletonMeta):
    _logger = None

    @classmethod
    def make_logger(cls, config_path: Path, request_id: str = "unknown-service"):
        config = cls.load_logging_config(config_path)
        if config is None:
            return None
        log_config: dict = config.get("logger", {})
        log_path = log_config.get("path", "")
        file_path = log_path + "/" + log_config.get("filename", "")
        logger_object = cls.config_logger(
            file_path,
            level=log_config.get("level"),
            retention=log_config.get("retention"),
            rotation=log_config.get("rotation"),
            formats=log_config.get("format"),
            request_id=request_id
        )
        if cls._logger is None:
            cls._logger = logger_object
        return logger_object

    @classmethod
    def config_logger(cls, filepath: Path, level: str, retention: str, rotation: str, formats: str,
                   request_id: str = "unknown-service"):
        """
        :param filepath: 日志输出路径
        :param level: 日志等级
        :param retention: 日志保留时间
        :param rotation: 日志分割，比如 1 days, 每天分割一个日志，不会堆积在一个日志文件中
        :param formats: 日志输出格式
        :param request_id: 项目id
        :return: Logger
        """
        logger.remove()
        # enqueue 加入消息队列，保证日志的完整性
        # backtrace 回溯
        logger.add(sys.stdout, enqueue=True, backtrace=True, level=level.upper(), format=formats)
        logger.add(str(filepath), encoding="utf-8", rotation=rotation, retention=retention, enqueue=True,
                   backtrace=True, level=level.upper(), format=formats)
        # 将fastAPI的日志添加到loguru中
        LOGGER_NAMES = ["uvicorn", "uvicorn.error", "fastapi", "uvicorn.asgi", "uvicorn.access"]
        logging.getLogger().handlers = [InterceptHandler(request_id=request_id)]
        for log_name in LOGGER_NAMES:
            __logger = logging.getLogger(log_name)
            __logger.handlers = [InterceptHandler(request_id=request_id)]

        return logger.bind(request_id=request_id)

    @classmethod
    def load_logging_config(cls, config_path: Path):
        config = None
        try:
            with open(config_path) as fp:
                config = json.load(fp)
        except Exception as error:
            logger.error("load logging config error!!")
        finally:
            return config


    @classmethod
    def get_logger(cls):
        return cls._logger
```





### third-party package -- JWT

jwt（JSON Web Tokens），在用户认证当中常用的方式，在如今的前后端分离项目当中应用广泛

>   JWT与传统的token的区别
>
>   传统token：服务端会对登录成功的用户生成一个随机token返回，同时也会在本地保留对应的token（如在数据库中存入：token、用户名、过期时间等）
>
>   JWT：服务端会对登录成功的用户生成一个随机token返回，但并**不会在服务端本地保留**



OAuth2中，可以有两种方式传递scope，表示这个接口需要哪些权限才可以查看



1.   使用Security方法在路由代码中传入

     ```python
     @security_router.get("/users/me/items")
     def read_own_items(current_user: User = Security(get_current_active_user, scopes=["items"])):
         return [{"item_id": "Foo", "owner": current_user.username}]
     ```

2.   在依赖项中传入

     ```python
     def get_current_active_user(current_user: User = Security(get_current_user, scopes=["me"])):
         if current_user.disabled:
             raise HTTPException(status_code=400, detail="Inactive user")
         return current_user
     
     ```

在使用 `jwt.encode(data)` 方法时，`data` 参数通常是一个字典，包含要加密的数据。以下是一些常见的键值对，可以填写在 `data` 中：
1.  `'iss'`（签发者）：表示JWT的签发者，通常是应用程序的名称或标识符。
2.  `'sub'`（主题）：表示JWT的主题，通常是用户的唯一标识符，用于识别JWT的持有者。
3.  `'aud'`（受众）：表示JWT的受众，通常是应用程序的名称或标识符，用于限制JWT的使用范围。
4.  `'exp'`（过期时间）：表示JWT的过期时间，通常是一个UNIX时间戳，以秒为单位。
5.  `'nbf'`（生效时间）：表示JWT的生效时间，即在此时间之前JWT是无效的。
6.  `'iat'`（签发时间）：表示JWT的签发时间，即JWT生成的时间。

### third-party package -- langchain

#### Summarization

官方文档：`https://python.langchain.com/docs/use_cases/summarization/`

将大文档和多个文档的内容进行汇总，有三个模式

1.   stuff: 这种最简单粗暴，会把所有的 document 一次全部传给 llm 模型进行总结。如果document很多的话，势必会报超出最大 token 限制的错，所以总结文本的时候一般不会选中这个。
2.   map_reduce: 这个方式会先将每个 document 进行总结，最后将所有 document 总结出的结果再进行一次总结。
3.   refine: 这种方式会先总结第一个 document，然后在将第一个 document 总结出的内容和第二个 document 一起发给 llm 模型在进行总结，以此类推。这种方式的好处就是在总结后一个 document 的时候，会带着前一个的 document 进行总结，给需要总结的 document 添加了上下文，增加了总结内容的连贯性。

## FAQ

### functools中，lru_cache和cache的区别

`functools.lru_cache`和`functools.cache`都是Python中的函数装饰器，用于缓存函数的结果以提高性能。它们的区别在于`lru_cache`使用了最近最少使用（LRU）算法来管理缓存，而`cache`则使用了最近最常使用（LFU）算法。



具体来说，`lru_cache`会保留最近调用的结果，当缓存满了时，会删除最久未使用的结果。这样可以确保缓存中一直保存着最常使用的结果，从而提高缓存命中率。

而`cache`则使用了最近最常使用（LFU）算法来管理缓存，它会根据每个结果的使用频率来决定是否保留在缓存中。

`lru_cache`还可以通过`maxsize`参数来限制缓存的大小

### 什么时候用同步，什么时候用异步

