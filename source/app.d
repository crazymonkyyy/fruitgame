import raylib;
import std;

void clamprw(T)(ref T a,T b,T c){
	if(a<b){a=b;return;}
	if(a>c){a=c;return;}
}
alias norm=Vector2Normalize;
alias scale=Vector2Scale;
enum windowx=920;//taken from sandtrix on my rotated monitor
enum windowy=500;
enum xmin=100;
enum xmax=400;
enum ymax=450;
enum easing=3;

struct ball{
	Vector2 v; alias v this;
	float size=0;
	int collisionindex=0;
}
ball[] balls;
void main(){
	InitWindow(windowx, windowy, "Hello, Raylib-D!");
	SetWindowPosition(1800,300);
	SetTargetFPS(360);
	while (!WindowShouldClose()){
		BeginDrawing();
			ClearBackground(Colors.BLACK);
			DrawText("hi",0,0,16,Colors.WHITE);
			foreach(i,ref b;balls){
				DrawCircleV(b,b.size,Colors.RED);
				b.collisionindex=-1;
			}
			foreach(i,ref b;balls){
				b.y+=1.0/6;
				b.x.clamprw(xmin,xmax);
				b.y.clamprw(-9999,ymax);
				foreach(j,ref c;balls[i+1..$]){
					//assert(b!=c);
					if(CheckCollisionCircles(b,b.size,c,c.size)){
						auto a=(b-c);
						auto a_=a.length-b.size-c.size;
						a_*=.45;
						a_.clamprw(-3,3);
						if(abs(a_)>.3){
							a=a.norm*a_;
							b-=a;
							c+=a;
						}
					}
					if(CheckCollisionCircles(b,b.size+easing,c,c.size)){
						if(b.collisionindex!=-1){
							DrawLineV(balls[b.collisionindex],c,Colors.YELLOW);
							DrawLineV(b,c,Colors.BLUE);
						}
						if(c.collisionindex!=-1){
							DrawLineV(balls[c.collisionindex],b,Colors.YELLOW);
							DrawLineV(b,c,Colors.BLUE);
						}
						c.collisionindex=cast(int)i;
						b.collisionindex=cast(int)(j+i+1);
					}
				}
			}
			import monkyyykeys;
			with(button){
			if(mouse1.pressed){
				balls~=ball(GetMousePosition,uniform(4,25));
			}
			
			
			}
			DrawFPS(0,30);
		EndDrawing();
	}
	CloseWindow();
}