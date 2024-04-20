## jsx语法规则

1. 定义虚拟DOM时，不要写引号

   ```html
   <script text='text/babel'>
   	const VDOM = (
           <h1>hello</h1>
       )
      </script>
   ```

2. 标签中混入JS表达式时要用{}

3. 样式的类名指定不要用class，要用className

4. 内联样式，要用style={{key:value}}的形式写。

5. 虚拟DOM必须只有一个根标签

6. 标签必须闭合。

7. 标签首字母

   - 若小写字母开头，则将该标签转为html中同名元素，若html中无该元素标签对应的同名元素，则报错。

     ```react
     <script text='text/babel'>
     	const VDOM = (
             <div>
             <h1>hello</h1>
             <good>123</good> /* 报错*/
             </div>
         )
        </script>
     ```

   - 若大写字母开头，react就去渲染对应的组件，若组件没有定义，则报错。

8. {}里的是js表达式，不是js代码

   ```react
   <script text='text/babel'>
   	const data = ["Angular","React","Vue"]
       const VDOM = (
               <div>
                   <h1>前端js框架列表</h1>
                   
                   <ul>
                       {
                           data.map((item,index) => {
                               return <li key={index}>{item}</li>
                           })
                       }
                   </ul>
                   </div>
           )
   
           // 2.渲染虚拟DOM到页面
           ReactDOM.render(VDOM,document.getElementById("test"))
      </script>
   ```

   

## 创建类式组件

有state（状态）的为复杂组件。类式组件创建

没有state（状态）的为简单组件。函数式组件创建

```react
<script type="text/babel">
        class MyComponent extends React.Component {
            render(){
                return <h2>类定义的组件，适用于【复杂组件】的定义</h2>
            }
        }
        // 2.渲染虚拟DOM到页面
        ReactDOM.render(<MyComponent/>,document.getElementById("test"))
    </script>
```

## 绑定事件

```react
<script type="text/babel">
        class Weather extends React.Component {
            constructor(props){
                super(props)
                this.state = {
                    isHot:true
                }
                this.changeWeather = this.changeWeather.bind(this)
            }
            render(){
                return (
                    <div>
                        <button onClick={this.changeWeather}>修改天气</button>
                        <h2>今天天气很{this.state.isHot?"炎热":"凉爽"}</h2> 

                    </div>
                )
            }
            changeWeather(){
                // this.state.isHot = !this.state.isHot
                // 不能直接修改state的状态，且合并
                this.setState({isHot:!this.state.isHot})
            }
        }
        // 2.渲染虚拟DOM到页面
        ReactDOM.render(<Weather/>,document.getElementById("test"))
    </script>
```

简写

```react
<script type="text/babel">
        class Weather extends React.Component {
            state = {
                isHot:true
            }
            render(){
                return (
                    <div>
                        <button onClick={this.changeWeather}>修改天气</button>
                        <h2>今天天气很{this.state.isHot?"炎热":"凉爽"}</h2> 
                    </div>
                )
            }
            changeWeather = () => {
                // this.state.isHot = !this.state.isHot
                // 不能直接修改state的状态，且合并
                this.setState({isHot:!this.state.isHot})
            }
        }
        // 2.渲染虚拟DOM到页面
        ReactDOM.render(<Weather/>,document.getElementById("test"))
    </script>
```

## props使用

```react
<script type="text/babel">
        class Person extends React.Component {
  
            render(){
                const {name,age,sex} = this.props
                return (
                    <ul>
                        <li>姓名：{name}</li>
                        <li>年龄：{age}</li>
                        <li>性别：{sex}</li>
                    </ul>
                )
            }
        }

        // 对标签属性进行类型、必要性的限制
        Person.propTypes = {
            name:PropTypes.string.isRequired, // 限制name必传，且为字符串
            sex:PropTypes.string,
            age:PropTypes.number,
            speak:PropTypes.func
        }
        // 指定默认标签的属性值
        Person.defaultProps = {
            sex:"中性",
            age:35
        }
        const obj = {
            name:"zhaoliu",
            age:20,
            sex:"男"
        }
        // 2.渲染虚拟DOM到页面
        ReactDOM.render(<Person name='lisi' age={18} sex="男"/>,document.getElementById("test"))
        ReactDOM.render(<Person name='wangwu' age={13} sex="女"/>,document.getElementById("test2"))
        ReactDOM.render(<Person {...obj}/>,document.getElementById("test3"))
    </script>
```

## refs使用

### String类型的Refs（运行效率慢）

```react
<script type="text/babel">
        class Demo extends React.Component {
            showDetail = ()=>{
                const {input1} = this.refs
                console.log(input1.value)
            }
            showDetail2 = ()=>{
                const {input2} = this.refs
                console.log(input2.value)
            }
            render(){
                return (
                    <div>
                    <input ref="input1" type="text" placeholder="請輸入字符串"/>
                    <button onClick={this.showDetail}>點擊觸發</button>
                    <input onBlur={this.showDetail2} ref="input2" type="text" placeholder="失去焦点"/>
                        </div>
                    
                )
            }
        }

        // 2.渲染虚拟DOM到页面
        ReactDOM.render(<Demo name='lisi' age={18} sex="男"/>,document.getElementById("test"))

    </script>
```

### 回调refs

```react
<script type="text/babel">
        class Demo extends React.Component {
            showDetail = ()=>{
                const {input1} = this
                console.log(input1.value)
            }
            showDetail2 = ()=>{
                const {input2} = this
                console.log(input2.value)
            }
            render(){
                return (
                    <div>
                    <input ref={ele =>{this.input1 = ele}} type="text" placeholder="請輸入字符串"/>
                    <button onClick={this.showDetail}>點擊觸發</button>
                    <input onBlur={this.showDetail2} ref={ele =>{this.input2 = ele}} type="text" placeholder="失去焦点"/>
                        </div>
                    
                )
            }
        }

        // 2.渲染虚拟DOM到页面
        ReactDOM.render(<Demo name='lisi' age={18} sex="男"/>,document.getElementById("test"))

    </script>
```

### createRef

```react
<script type="text/babel">
        class Demo extends React.Component {
            showDetail = ()=>{
                // const {input1} = this
                console.log(this.myRef.current.value)
            }
            showDetail2 = ()=>{
                const {input2} = this
                console.log(this.myRef2.current.value)
            }
            myRef = React.createRef()
            myRef2 = React.createRef()
            render(){
                return (
                    <div>
                    {/*<input ref={ele =>{this.input1 = ele}} type="text" placeholder="請輸入字符串"/>*/}
                    <input ref={this.myRef} type="text" placeholder="請輸入字符串"/>
                    <button onClick={this.showDetail}>點擊觸發</button>
                    <input onBlur={this.showDetail2} ref={this.myRef2} type="text" placeholder="失去焦点"/>
                        </div>
                    
                )
            }
        }

        // 2.渲染虚拟DOM到页面
        ReactDOM.render(<Demo name='lisi' age={18} sex="男"/>,document.getElementById("test"))

    </script>
```

## 生命周期

### 旧版（16.x）

1. 初始化阶段：由ReactDOM.render()出发--初次渲染

   1. constructor()

   2. componentWillMount()

   3. render()

   4. componentDidMount() ===>常用

      > 一般在这个钩子中做一些初始化的事

2. 更新阶段：由组件内部this.setState()或父组件重新render触发

   1. shouldComponentUpdate()
   2. componentWillUpdate()
   3. render()
   4. componentDidUpdate()

3. 卸载组件：由ReactDOM.unmountComponentAtNode()触发

   1. componentWillUnmount() ===>常用

      > 一般在这个钩子中做一些收尾的事

### 新版（17.x以上）

1. 初始化阶段：由ReactDOM.render()出发--初次渲染

   1. constructor()

   2. getDerivedStateFromProps()

   3. render()

   4. componentDidMount() ===>常用

      > 一般在这个钩子中做一些初始化的事

2. 更新阶段：由组件内部this.setState()或父组件重新render触发

   1. getDerivedStateFromProps()
   2. shouldComponentUpdate()
   3. render()
   4. getSnapshotBeforeUpdate()
   5. componentDidUpdate()

3. 卸载组件：由ReactDOM.unmountComponentAtNode()触发

   1. componentWillUnmount() ===>常用

      > 一般在这个钩子中做一些收尾的事

卸载组件

`ReactDOM.unmountComponentAtNode(document.getElementById('test'))`

```react
    <script type="text/babel">
        class Weather extends React.Component {
            
            // 挂载后
            componentDidMount(){
                console.log("componentDidMount")
            }
            // 组件将要被卸载
            componentWillUnmount(){
                console.log("componentWillUnmount")
            }

            //控制组件更新的“阀门”
            // 当shouldComponentUpdate()返回false，则不允许更新
            // 调用setState()则会调用此函数
            shouldComponentUpdate(){
                console.log("shouldComponentUpdate")
                return true
            }
            // 组件将要更新
            componentWillUpdate(){
                console.log("componentWillUpdate")
            }
            
            // 组件更新完毕
            componentDidUpdate(){
                console.log("componentDidUpdate")
            }
            updateRender = ()=> {
                this.forceUpdate()
            }
            render(){
                return (
                    <div>
                        <h1>测试周期函数</h1>
                        <button onClick={this.updateRender}>强制更新，无视阀门</button>
                    </div>
                )
            }
        }
        // 2.渲染虚拟DOM到页面
        ReactDOM.render(<Weather/>,document.getElementById("test"))
    </script>
```





## 脚手架

全局安装：`npm install -g create-react-app`

创建项目的目录：`create-react-app myblog-react`

进入项目文件夹：`cd myblog-react`

启动项目：`npm start`

## 消息订阅-发布机制

1. 工具：PubSubJS
2. 下载：`npm install pubsub-js --save`
3. 使用：
   1. `import PubSub from 'pubsub-js' // 引入`
   2. `PubSub.subscribe('delete',(msg,data)=>{})  //订阅，用在挂载函数里`
   3. `PubSub.publish("delete",data) // 发布消息`

## 路由

1. 下载：`npm install react-router-dom@5.2.0`

2. 路由管理

   ```jsx
   // index.js入口文件
   import React from "react";
   import reactDOM from "react-dom";
   import {BrowserRouter} from 'react-router-dom';
   ;
   
   import App from "./App"
   // 在App外壳包一层BrowserRouter组件
   reactDOM.render(<BrowserRouter><App/></BrowserRouter>,document.getElementById("root"))
   ```

3. 路由的基本使用

   ```text
   1. 明确好界面中的导航区、展示区
   2. 导航区的a标签改为Link标签
   <Link to="/about"></Link>
   3. 展示区写Route标签进行路径的匹配
   <Route path="/about" component={Demo}/>
   4. <App>的最外侧包裹一个<BrowserRouter>或者<HashRouter>
   ```

   

### 封装NavLink或者Link标签

原始NavLink写法

```html
<NavLink activeClassName="test" className="list-group-item" to="/home">Home</NavLink>
<NavLink activeClassName="test" className="list-group-item" to="/about">About</NavLink>
```

自定义封装一个Link

1. html页面修改

```html
<MyNavLink to="/home">Home</MyNavLink>
<MyNavLink to="/about">About</MyNavLink>
```

2. 封装MyNavLink

   ```react
   /*
   props = {
   	to:"/path",
   	a:"1",
   	children:"About" // children为标签的文本内容
   }
   */
   export default class MyNavLink extends Component {
       render(){
           return (
           	<NavLink activeClassName="test" className="list-group-item" {...this.props}/>
           )
       }
   }
   ```

### Switch的使用

1. 通常情况下，path和component是一一对应的关系。
2. Switch可以提高路由匹配效率（单一匹配）

```react
<Switch>
    <Route path="/about" component={About}>
    <Route path="/home" component={Home}>
</Switch>
```

### 路由严格匹配

exact

```react
<Switch>
    <Route exact={true} path="/about" component={About}>
    <Route exact={true} path="/home" component={Home}>
</Switch>
```



### Redirect重定向

当路由都匹配不上时，重定向到一个路由

```react
<Switch>
    <Route exact={true} path="/about" component={About}>
    <Route exact={true} path="/home" component={Home}>
    <Redirect to="/about"/>
</Switch>
```



### 向路由组件传递参数

1. params参数

   >路由连接（携带参数）：`<Link to='/demo/test/tom/18'>详情</Link>`
   >
   >注册路由（声明接收参数）：`<Route path="/demo/test/:name/:age" component={Test}>`
   >
   >接收参数：const {name,age} = this.props.match.params

2. search参数

   >路由链接（携带参数）：`<Link to='/demo/test?name=tom&age=18'>详情</Link>`
   >
   >注册路由：`<Route path="/demo/test" component={Test}/>`
   >
   >接收参数： `const {search} = this.props.location`
   >
   >备注：获取的search时urlencoded编码字符串，需要借助querystring解析

3. state参数

   > 路由链接（携带参数）：`<Link to={{path:'/demo/test',state:{name:'tom',age:18}}}>详情</Link>`
   >
   > 注册路由：`<Route path="/demo/test" component={Test}>`
   >
   > 接收参数：this.props.location.state
   >
   > 备注：刷新也可以保留住参数

### 编程式路由导航

借助this.props.history对象上的API操作路由



## 流行React UI组件库

1. ant-design（国内蚂蚁金服）

   `https://ant.design/index-cn`

2. material-ui(国外)

   `http://www.material-ui.com`

### antd的按需引入+自定义主题

1. 安装依赖：`npm install react-app-rewired customize-cra babel-plugin-import less@3.12.2 less-loader@7.1.0`

2. 修改package.json

   ```text
   ...
   "scripts":{
   	"start": "react-app-rewired start",
       "build": "react-app-rewired build",
       "test": "react-app-rewired test",
       "eject": "react-scripts eject"
   }
   ```

3. 根目录下创建config-overrides.js

   ```text
   //配置具体的修改规则
   const { override, fixBabelImports,addLessLoader } = require('customize-cra');
   module.exports = override(
   	fixBabelImports('import',{
   		libraryName:'antd',
   		libraryDirectory:'es',
   		style:true
   	}),
   	addLessLoader({
   		lessOptions:{
   			javascriptEnabled:true,
   			modifyVars:{ '@primary-color':'green' }
   		}
   	}),
   );
   ```

4. 备注：不用在组件里亲自引入样式了

### 按需引入-4.x

1. 下载：`npm install babel-plugin-import less less-loader --save-dev`

2. 在package.json添加以下配置：

   ```text
    ...,
    "babel": {
       "presets": [
         "react-app"
       ],
       "plugins": [
         [
           "@babel/plugin-proposal-decorators",
           {
             "legacy": true
           }
         ],
         [
           "import",
           {
             "libraryName": "antd",
             "libraryDirectory": "es",
             "style": true
           }
         ]
       ]
     },
   ```

3. 在App.css文件中添加`@import "~antd/dist/antd.css"`

4. 在App.js文件中添加`import "./App.css"`

## 修改antd主题色

```less
@primary-color: #1890ff; // 全局主色
@link-color: #1890ff; // 链接色
@success-color: #52c41a; // 成功色
@warning-color: #faad14; // 警告色
@error-color: #f5222d; // 错误色
@font-size-base: 14px; // 主字号
@heading-color: rgba(0, 0, 0, 0.85); // 标题色
@text-color: rgba(0, 0, 0, 0.65); // 主文本色
@text-color-secondary: rgba(0, 0, 0, 0.45); // 次文本色
@disabled-color: rgba(0, 0, 0, 0.25); // 失效色
@border-radius-base: 2px; // 组件/浮层圆角
@border-color-base: #d9d9d9; // 边框色
@box-shadow-base: 0 3px 6px -4px rgba(0, 0, 0, 0.12), 0 6px 16px 0 rgba(0, 0, 0, 0.08),
  0 9px 28px 8px rgba(0, 0, 0, 0.05); // 浮层阴影
```



## redux

### redux精简版

1. 去除Count组件自身的状态

2. src目录下建立：

   -redux

   ​	-store.js

   ​	-count_reducer.js

3. store.js

   ```text
   1. 引入redux中的createStore函数，创建一个store
   2. createStore调用时传入一个为其服务的reducer
   3. 暴露store对象
   ```

4. count_reducer.js

   ```text
   1. reducer的本质是一个函数，接收：preState,action，返回加工后的状态
   2. reducer有两个作用：初始化状态，加工状态
   3. reducer被第一次调用时，时store自动触发，传递的preState时undefined
   ```

5. 使用store.subscribe(()=>{})来监测store状态是否更新

### react-redux的基本使用

1. 明确两个概念：

   1. UI组件，不能使用任何redux的api，只负责页面的呈现、交互等
   2. 容器组件：负责和redux通信，将结果交给UI组件

2. 如何创建一个容器组件--靠react-redux的connect函数

   ```react
   // 引入Count的UI组件
   import CountUI from "../components/Count"
   // 引入connect用于连接UI组件与redux
   import { connect } from "react-redux"
   import { createIncrementAction, createDecrementAction, createIncrementAsyncAction } from "../redux/count_action"
   
   
   /**
    * 
    * 1.mapStateToProps函数返回的是一个对象
    * 2.返回对象中的key作为传递参数给UI组件的props的key,value为props的value
    * 3.mapStateToProps用于传递状态
    */
   function mapStateToProps(state) { 
       return {count:state}
   }
   
   /**
    * 1. mapDispatchToProps函数返回的是一个对象
    * 2. 返回对象中的key作为传递参数给UI组件的props的key,value为props的value
      3. mapDispatchToProps用于传递操作状态的方法
    */
   function mapDispatchToProps(dispatch) { 
       return {
           increment: (number) => { 
               dispatch(createIncrementAction(number))
           },
           decrement: (number) => { 
               dispatch(createDecrementAction(number))
           },
           incrementAsync: (number,time) => { 
               dispatch(createIncrementAsyncAction(number,time))
           }
       }
   }
   
   export default connect(mapStateToProps,mapDispatchToProps)(CountUI)
   ```

3. 备注：容器组件中的store是靠props传进去的，而不是在容器组件中直接引入

4. 备注：mapDispatchToProps也可以是一个对象，react-redux会自动调用dispatch()

5. 不需要使用store.subscibe()监听，react-redux会自动监听

### react_redux优化

1. 容器组件和UI组件混成一个文件

2. 无需自己给容器组件传递store，给`<App/>`包裹一个`<Provider store={store}>`即可

3. 使用react-redux后也不用再自己监测redux中的状态改变，容器自动完成这个工作

4. mapDispatchToProps也可以简单的写成一个对象。

5. 一个组件要和redux打交道经过以下步骤：

   1. 定义好UI组件--不暴露

   2. 引入connect生成一个容器组件，并暴露

      ```text
      connect(
      state => ({key:value}),  // 映射状态
      {key:xxxxAction}  // 映射操作状态的方法
      )(UI组件)
      ```

   3. 在UI组件中通过this.props.xxxxx读取和操作状态

### react-redux数据共享版

1. 定义一个Person组件，和Count组件通过redux共享数据

2. 为Person组件编写：reducer,action,配置constant常量

3. 重点：Person的reducer和Count的Reducer要使用combineReducers进行合并

   ```text
   // 引入createStore,专门用于创建redux中最核心的store对象
   import { createStore,applyMiddleware,combineReducers } from 'redux';
   import countReducer from "./reducers/count"
   import personReducer from "./reducers/person"
   import thunk from 'redux-thunk';
   
   const allReducers = combineReducers({
       count: countReducer,
       person:personReducer
       
   })
   export default createStore(allReducers,applyMiddleware(thunk))
   ```

## 拓展点

### setState更新状态的两种写法

setState(stateChange,[callback]) --- 对象式setState

1. stateChange为状态改变对象
2. callback是可选的回调函数，它在状态更新完毕后，界面也更新后执行。

setState(updater,[callback]) -- 函数式setState

1. updater为返回stateChange对象的函数
2. updater可以接收到state和props
3. callback是可选的回调函数，它在状态更新完毕后，界面也更新后执行。

总结：

1. 对象式的setState是简写模式
2. 快用原则：
   	1. 如果新状态不依赖于原状态 ==>使用对象方式
    	2. 如果新状态依赖于原装胎  ==>使用函数方式
    	3. 如果需要在setState()执行后获取最新的状态数据，要在第二个callback函数中读取

### 懒加载lazyload

1. 用于路由组件的懒加载

2. 使用：

   ```react
   import {lazy} from "react"
   const Home = lazy(()=>import("./Home"))
   const About = lazy(()=>import("./About"))
   
   export default class Demo extends Component {
       render(){
           return (
           ....
               <NavLink to="/home">Home</NavLink>
               <NavLink to="/about">About</NavLink>
           .....
           {/*注册路由外层包裹一个Suspense标签*/}
       	<Suspense>
       		<Route path='/about' component={About}/>
               <Route path='/home' component={Home}/>
       	</Suspense>
           )
       }
   }
   
   ```



### 函数式组件hooks

1. react16.8推出hooks，新增加的特性，新语法
2. 可以让函数组件中使用state以及其他React特性

---

#### 三个常用的Hook

1. State Hook：`React.useState()`
2. Effect Hook：`React.useEffect()`
3. Ref Hook：`React.useRef()`

#### State Hook

1. State Hook让函数组件也可以有state状态，并进行状态数据的读写操作
2. 语法：const [xxx,setXxxx] = React.useState(initValue)
3. useState()说明
   1. 参数：第一次初始化指定的值在内部作缓存
   2. 返回值：包含两个元素的数组，第一个为内部的值，第二个为更新状态值的函数
4. setXxx()的两种写法
   1. setXxx(newValue):参数为非函数值，直接指定新的状态值，内部用其覆盖原来的状态值
   2. setXxx(value => newValue)

#### Effect Hook

1. Effect Hook可以让你在函数组件中执行副作用操作（用于模拟类组件中的生命周期钩子）

2. React中的副作用操作：

   1. 发送ajax请求数据获取
   2. 设置订阅/启动定时器
   3. 手动更改真实DOM

3. 语法和说明：

   ```text
   React.useEffect(()=>{
   	// 在此可以执行任何带副作用操作
   	return ()=>{
   		// 在组件卸载前执行
   		// 在此做一些收尾工作，比如清楚定时器/取消订阅等
   	}
   },[stateValue]) // 如果指定的是[],回调函数指挥在第一次render()后执行，用于监听state状态数据的改变调用。
   ```

4. 可以把useEffect Hook 看作三个周期函数的组合

   1. componentDidMount()
   2. componentDidUpdate()
   3. componentWillUnmount()

#### Ref Hook

1. Ref Hook 可以在函数组件中存储/ 查找组件内的标签或任意其他数据
2. 语法：`const refContainer = useRef()`
3. 作用：保存标签对象，功能于createRef()一样

### Fragment

1. 作用：可以不用必须有一个真实DOM根标签

2. 使用：

   ```text
   <Fragment><Fragment>
   <></>
   ```

   

### Context

1. 一种组件间通信方式，常用于【祖祖件】于【后代组件】通信

2. 使用：

   ```text
   1.创建Context容器对象
   const MyContext = Rect.createContext()
   const {Provider,Consumer} = MyContext
   2.渲染子组时，外面包裹一层Provider标签
   <Provider value={数据}>
   子组件
   </Provider>
   3.后代组件读取数据：
   <Consumer>
   {
   	value => {
   		return value
   	}
   }
   </Consumer>
   ```

   

## 知识点

1. 设计状态时需要考虑全面，例如带有网络请求的组件，要考虑请求失败怎么办。

## 项目开发错误点

### This git repository has untracked files or uncommitted changes

在`npm run eject`暴露配置文件过程中报错。

`error : This git repository has untracked files or uncommitted changes`

解决方法：

发布git上



## 数据可视化

1. 下载

   `npm install --save echarts`

   `npm install --save echarts-for-react`

2. 使用

   ```jsx
   import React, { Component } from 'react'
   import { Page } from 'sdcube';
   // import axios from 'axios';
   import echarts from 'echarts/lib/echarts';
   import ReactEcharts from "echarts-for-react";
   export default class Visualization extends Component {
     getOptions = () => {
       let option = {
         xAxis: {
           type: 'category',
           data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
         },
         yAxis: {
           type: 'value'
         },
         series: [
           {
             data: [150, 230, 224, 218, 135, 147, 260],
             type: 'line'
           }
         ]
       }
       return option
     }
   
     render() {
       return (
         <Page>
           <ReactEcharts option={this.getOptions()}></ReactEcharts>
         </Page>
   
       )
     }
   }
   
   ```

   

## 上下文context

作用：使用 context, 我可以避免通过中间元素传递 props

1. 在`src/contextManager.js`中编辑

```js
import React from 'react';

export const GraduateSubsidy = React.createContext(null);

```



2. 在组件中使用

```jsx
....
import { GraduateSubsidy } from "src/contextManager"
return (
    <GraduateSubsidy.Provider value={{
            selectList,
      setSelectList,
      refresh,
      page,
      data,
      loading,
      setPage,
      tableType,
      setTableType
        }}>
    ....
    </GraduateSubsidy.Provider>
)
```

3. 获取上下文内容

```jsx
import React, { useContext } from 'react';
import { GraduateSubsidy } from "src/contextManager"
export default function () {
    const { page, selectList, setSelectList, setPage, refresh, data, loading, tableType, setTableType } = useContext(GraduateSubsidy);
}
```



## 字符串转json

eval('(' + explain + ')')



## 跳转对应的面板

```jsx
// 面版对应的id，document.getElementById("root").scrollIntoView()
const scrollToAnchor = (anchorName) => {
  if (anchorName) {
    let anchorElement = document.getElementById(anchorName);
    if (anchorElement) { anchorElement.scrollIntoView(); }
  }
};

```





## 桌面软件开发electron

### 打包

1. react项目打包

   - 修改main.js,加载应用换成打包代码
   - npm run build

2. electron打包

   - 下载electron-packager `npm install electron-packager --save-dev`

   - 安装electron-packager指令  `npm install electron-packager -g`

   - `electron-packager <location of project> <name of project> <platform> <architecture> <electron version> <optional options>`

     location of project: 项目的本地地址，此处我这边是 ~/knownsec-fed
     location of project: 项目名称，此处是 knownsec-fed
     platform: 打包成的平台
     architecture: 使用 x86 还是 x64 还是两个架构都用
     electron version: electron 的版本

   为了便捷打包，在package.json中配置electron的打包指令

   ```js
   "scripts": {
       "start": "craco start",
       "build": "craco build",
       "test": "craco test",
       "eject": "react-scripts eject",
       "electron-start": "electron .",
       "package": "electron-packager ./ react_job --platform=win32 --out=./dist --electron-version 19.0.4" 
     },
   
   ```

## 启动electron遇到的坑

1. 下载过程中可能会失败

设置electron的下载镜像源 `npm config set electron_mirror "https://npm.taobao.org/mirrors/electron/"`

2. electron启动失败

   没有下载全局：`npm install -g electron`

3. unable to find electron app ....

   package.json配置文件中少配置了"main"进入配置



## 获取镜像源

**npm get registry**

## 设置镜像源

`npm config set registry http://registry.npm taobao.org/`



## setupProxy.js不生效

### setupProxy.js放置位置错误

应该放在项目的src目录下

### 新版的代理需要使用createProxyMiddleware



## axios返回对象为文件对象，下载文件

同时处理blob文件和json返回数据

```jsx
axios({
            method: 'post',
            url: '/reissue/exportRepayFile',
            responseType: 'blob',
            data: data
        })
    .then(response => {
    if (response.data.type === "application/json") {
        const reader = new FileReader();  //创建一个FileReader实例
        reader.readAsText(response.data, 'utf-8'); //读取文件,结果用字符串形式表示
        reader.onload=function(){//读取完成后,**获取reader.result**
            let res = JSON.parse(reader.result)
            if (res.code === -1) {
                message.error(res.msg)
            } else { 
                message.success(res.msg)
            }

        }
    } else { 
        const blob = new Blob([response.data]);
        const fileName = type === 0 ? `${moment().format('YYYYMMDD')}补发申请表.xls` : `${moment().format('YYYYMMDD')}补发花名册.xls`;
        if ('download' in document.createElement('a')) {
            // 非IE下载
            const url = window.URL.createObjectURL(blob);
            let a = document.createElement('a');
            a.href = url;
            a.download = fileName;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);
        } else {
            navigator.msSaveBlob(blob, fileName);
        }
    }

});
```



## 基本下载包

1. axios： `npm i axios --save`
2. antd:   `npm i antd@4.19.0 --save`
3. antd按需引入：`npm install babel-plugin-import less less-loader --save-dev`
4. http-proxy-middleware:`npm i http-proxy-middleware --save`
5. react-router-dom:`npm install react-router-dom@5.2.0`

antd修改主题色：

1. 下载craco:`npm i craco craco-less`

2. 项目目录配置craco.config.js

   ```js
   const CracoLessPlugin = require('craco-less');
   module.exports = {
     plugins: [
       {
         plugin: CracoLessPlugin,
         options: {
           lessLoaderOptions: {
             lessOptions: {
               modifyVars: { '@primary-color': "#63c0b5" },
               javascriptEnabled: true,
             },
           },
         },
       },
     ],
   };
   ```

3. 修改package.json

   ```json
   {
       ...,
     "scripts": {
       //"start": "react-scripts start",
       //"build": "react-scripts build",
       //"test": "react-scripts test",
       "start": "craco start",
       "build": "craco build",
       "test": "craco test",
       "eject": "react-scripts eject"
     },
   }
   ```

4. 修改其他主题色

   ```less
   // App.less
   @import '~antd/dist/antd.less';
   @primary-color: #1890ff; // 全局主色
   @link-color: #1890ff; // 链接色
   @success-color: #52c41a; // 成功色
   @warning-color: #faad14; // 警告色
   @error-color: #f5222d; // 错误色
   @font-size-base: 14px; // 主字号
   @heading-color: rgba(0, 0, 0, 0.85); // 标题色
   @text-color: rgba(0, 0, 0, 0.65); // 主文本色
   @text-color-secondary: rgba(0, 0, 0, 0.45); // 次文本色
   @disabled-color: rgba(0, 0, 0, 0.25); // 失效色
   @border-radius-base: 2px; // 组件/浮层圆角
   @border-color-base: #d9d9d9; // 边框色
   @box-shadow-base: 0 3px 6px -4px rgba(0, 0, 0, 0.12), 0 6px 16px 0 rgba(0, 0, 0, 0.08),
     0 9px 28px 8px rgba(0, 0, 0, 0.05); // 浮层阴影
   ```

   



## 页面展示docx、xlsx文件

1. 下载`react-file-viewer`

   `npm i react-file-viewer`

2. 使用

   ```react
   import FileViewer from "react-file-viewer"
   
   <FileViewer
   fileType='docx'//文件类型
   filePath={url} //文件地址
   />
   ```
   
   

## antd Table组件手动调节列宽

下载`React-Resizable`:`npm i React-Resizable`



## antd Table组件components参数的使用

场景：给符合条件的每一行添加Tooltip组件

结合rowClassName使用

```react
const EditableRow = ({ index, ...props }) => {
  return (
    <Tooltip>
      <tr {...props} />
    </Tooltip>
        
     
  );
};
const EditableCell = ({
  title,
  editable,
  children,
  dataIndex,	
  record,
  handleSave,
  ...restProps
})=>{
   return <td {...restProps}>{childNode}</td>;
}

const components = {
  body: {
    row: EditableRow,
    cell: EditableCell
  }
};


  const rowClassName = (record) => {
    if (record.doubtType != "undefined" && record.doubtType != null && record.doubtType === 0) {
      return "selected-doubt-black"
    }
    if (!record.isIdentify) {
      return 'selected-row'
    }

  };



export default function (){
    return (
    <Table
      components={components}
      rowClassName={rowClassName}
      
  );
}
```





## 使用@代替src目录



1. 执行`npm run eject`暴露配置文件

2. 编辑`config/webpack.config.js`

    ```js
    // 
    resolve {
        alias: {
            //...
            // 添加一行配置
            '@': paths.appSrc
        }
    }
    ```

    
