# CircleNavigationDemo
###About
This is a Demo for my Circle Navigation Components
`CircleNavigationItem` and `CircleNavigation` are two core class

cocoapod depends
```ruby
pod 'Masonry'
pod 'pop', '~> 1.0'
```

###Usage

Just like follow code

```objective-c
    CircleNavigation *circle = [CircleNavigation create];
    circle.delegate = self;
    [self.view addSubview:circle];
    [circle setupWithIcon:[UIImage imageNamed:@"image"] itemImages:@[[UIImage imageNamed:@"image"], [UIImage imageNamed:@"image"], [UIImage imageNamed:@"image"], [UIImage imageNamed:@"image"]] 
    radius:80 iconSize:CGSizeMake(32, 32) itemSize:CGSizeMake(32, 32)];
```

`itemImages` accepts a array of iconimage of item

`radius` configure the distence between item of center icon

`iconSize` configure center icon's size

`itemSize` configure item's size

you should implements protocol `CircleNavigationDelegate` to get index of what you click
