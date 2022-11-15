// Console.cpp : CxImage console demo.

#include "stdafx.h"
#include <io.h>
#include <stdlib.h>  
#include <time.h>
#include "ximage.h"

#define DIVIDER 250

#define  MAX(a,b) (((a) > (b)) ? (a) : (b))
#define  MIN(a,b) (((a) < (b)) ? (a) : (b))
#define  CLIP(a,_min_,_max_)  (((a) > (_max_)) ? (_max_) : MAX(a,_min_))

TCHAR* FindExtension(const TCHAR * name);
TCHAR* CutExtension(TCHAR * name);
int	convert_image_types( TCHAR *input_image , int typein , TCHAR *output_image , int typeout );
int	convert_image_type(  TCHAR *input_image , int typein , TCHAR *output_image , int typeout );

void Color2Text(char* dest, unsigned int color)
{
	char res[10];
	res[0] = '{';
	res[7] = '}';
	res[8] = 'g';
	res[9] = 0;
	char c = color % 16;
	for(int i = 0; i<6; i++)
	{
		char c = color % 16;
		c += 0x30;
		if(c >= 0x3a)
			c+=7;
		res[6-i] = c;
		color /= 16;
	}
	memcpy(dest, res, 10);
}

struct BlockData
{
	char colors[4096];
	int count;
};

void BuildString(char* dest, unsigned int *src, int w, int h)
{
	dest[0] = 0;
	int len = 0;
	char temp_string[16];
	int tres = 100000;
	char ret[] = "\\\n";
	unsigned int prev_color = src[0] + 1;
	for(int j = 0; j<h; j++)
	{
		for(int i = 0; i < w; i++)
		{
			int index = i + j*15;
			if (prev_color != src[index])
			{
				prev_color = src[index];
				Color2Text(temp_string, src[index]);
				len += strlen(temp_string);
				if (len > tres)
				{
					strcat(dest, ret);
					len = 0;
				}
				strcat(dest, temp_string);
			}
			else
			{
				len++;
				if (len > tres)
				{
					strcat(dest, ret);
					len = 0;
				}
				strcat(dest, "g");
			}
		}
		len+=2;
		if (len > tres)
				{
					strcat(dest, ret);
					len = 0;
				}
		strcat(dest,"\\n");
	}
}


void CutBlock15(CxImage &pic, unsigned int* dest, int x, int y)
{
	int w = pic.GetWidth();
	int h = pic.GetHeight();
		for (int i = 0; i < 15; i++)
			for (int j = 0; j < 15; j++)
			{
				int di_x = x*15 + i;
				int di_y = y*15 + j;
				if(di_x < w && di_y < h)
				{
					RGBQUAD color = pic.GetPixelColor(di_x, h-di_y-1, false);
					dest[i + j*15] = ((unsigned int)color.rgbBlue) + 0x100*((unsigned int)color.rgbGreen) + 0x100*0x100*((unsigned int)color.rgbRed);
				}
				else
					dest[i + j*15] = 0;
			}
	}

////////////////////////////////////////////////////////////////////////////////
#ifdef UNICODE
int wmain( int argc, TCHAR *argv[] )
#else
int main( int argc, TCHAR *argv[] )
#endif
{
	int status = 0;
	srand (time(NULL));
	rand(); rand();
    if (argc!=2) {
        _ftprintf(stderr, _T("\nDialUp SART Converter v0.0\n"));
        _ftprintf(stderr, _T("Drag-n-Drop any picture on the exe file!\n"), argv[0]);
        system("pause");
        return 1;
    }

	// See if arg 1 is a valid image type
	TCHAR* extin = FindExtension(argv[1]);
	_tcslwr(extin);
	int typein = CxImage::GetTypeIdFromName(extin);
	if (typein == CXIMAGE_FORMAT_UNKNOWN) {
        _ftprintf(stderr, _T("unknown extension for %s\n"), argv[1]);
		system("pause");
        return 1;
	}
	CxImage image;

	if(!image.Load(argv[1],typein))
	{
		_ftprintf(stderr, _T("%s\n"), image.GetLastError());
		_ftprintf(stderr, _T("error loading %s\n"), argv[1]);
		system("pause");
		return 1;
	}	
	int width = image.GetWidth();
	int height = image.GetHeight();
	int blx = ceil( double(width) / 15 );
	int bly = ceil( double(height) / 15 );
	TCHAR cutname[4096] = {0};
	_tcscpy(cutname, argv[1]);
	TCHAR *finame = CutExtension(cutname);
	FILE * resin = NULL;
	TCHAR outname[4096] = {0};
	_tcscpy(outname, finame);
	_tcscat(outname, _T(".inc"));
	_tfopen_s(&resin, outname, _T("w"));
	if (resin == NULL)
	{
		_ftprintf(stderr, _T("error creating %s\n"), outname);
		system("pause");
		return 1;
	}
	//make array name
	char arrname[0x21] = {0};
	bool name_is_bad = false;
	for (int i = 0; i < 0x20; i++)
	{
		char c = (char)finame[i];
		if (c == 0)
			break;
		if ( ( c >= 'a' && c <= 'z') || ( c >= '0' && c <= '9' && i !=0 ) || c == '_')
			c = c;
		else if ( ( c >= 'A' && c <= 'Z') )
			c = tolower(c);
		else
		{
			name_is_bad = true;
			break;
		}
		char strpart[2] = {0};
		strpart[0] = c;
		strcat(arrname, strpart);
	}
	if (name_is_bad)
	{
		int rndm = rand() % 10000;
		_tprintf(_T("Pic name isn't good for pawn, using default name\n"));
		sprintf(arrname, "new_art_%d", rndm);
	}
	//prepare blocks data
	BlockData * barra = (BlockData*)malloc(sizeof(BlockData)*blx*bly);
	unsigned int *temp_block = (unsigned int*)malloc(15*15*sizeof(unsigned int));
	int total_count = 0;
	for (int by = 0; by < bly; by++)
		for (int bx = 0; bx < blx; bx++)
		{
			memset(temp_block, 0, sizeof(unsigned int)*15*15);
			CutBlock15(image, temp_block, bx, by);
			char colors[0x1000] = {0};
			int cur_w = CLIP(width - bx*15,0,15);
			int cur_h = CLIP(height - by*15,0,15);
			BuildString(colors, temp_block, cur_w, cur_h);
			strcpy(barra[bx + by*blx].colors, colors);
			barra[bx + by*blx].count = ceil( double(strlen(colors)) / DIVIDER);
			total_count += barra[bx + by*blx].count;
		}
	free(temp_block);
	//output settings array
	fprintf(resin, "new %s[%d][] = {\n", arrname, total_count + 1);
	
	fprintf(resin, "{ %d, %d", blx, bly);
	int cur_buf = 1;
	for (int i = 0; i < blx*bly; i++)
	{
		fprintf(resin, ", %d, %d", barra[i].count, cur_buf);
		cur_buf += barra[i].count;
		if (i % (DIVIDER/9) == DIVIDER/9 - 1)
			fprintf(resin, "\n");
	}
	fprintf(resin, "}\n");
	//output blocks data
	char temp_buf[DIVIDER+1] = {0};
	for (int i = 0; i < blx*bly; i++)
	{
		char * cur_str = barra[i].colors;
		for(int k = 0; k < barra[i].count - 1; k++)
		{
			memcpy(temp_buf, cur_str, DIVIDER);
			char * new_str = temp_buf + DIVIDER - 1;
			while(*new_str != 'g' && new_str != temp_buf)
				new_str--;
			if (new_str == temp_buf && *new_str != 'g')
			{
				_tprintf(_T("ERROR HAPPENED! SORRY!\n"));
				printf("%s", temp_buf);
				system("pause");
				exit(-1);
			}
			*new_str = 0;
			cur_str = (new_str - temp_buf) + cur_str;
			fprintf(resin, ", \"%s\"\n", temp_buf);
		}
		fprintf(resin, ", \"%s\"\n", cur_str);
	}
	fprintf(resin, "};\n");
	fclose(resin);
	free(barra);
	_tprintf(_T("Done!\n"));
	system("pause");
	return 0;
}

////////////////////////////////////////////////////////////////////////////////
TCHAR* FindExtension(const TCHAR * name)
{
	int len = _tcslen(name);
	int i;
	for (i = len-1; i >= 0; i--){
		if (name[i] == '.'){
			return (TCHAR*)(name+i+1);
		}
	}
	return (TCHAR*)(name+len);
}

TCHAR* CutExtension(TCHAR * name)
{
	int len = _tcslen(name);
	int i;
	for (i = len-1; i >= 0; i--){
		if (name[i] == '.'){
			name[i] = 0;
		}
		if (name[i] == '/' || name[i] == '\\'){
			return name + i + 1;
		}
	}
	return name;
}