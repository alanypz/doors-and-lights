using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media;

namespace City_Of_Orlando_Automated_Controller
{
    public static class Utility
    {
        public static User user = null;
        public static Component[] components = null;
        public static int componentIndex = 0;
        public static Button[] componentButtons = null;
        public static ImageBrush doorBrush = null;
        public static ImageBrush lightBrush = null;
        public static object[] lrDoors = null;
        public static object[] lrLights = null;
        public static string title { get; set; }
        public static int fail { get; set; }
        public static int stop { get; set; }
        public static string ip = "http://localhost:8080";
        //public static string ip = "http://10.0.0.2:8080";
        //public static string ip = "http://Alans-MacBook-Pro.local";
        //public static string ip = "http://132.170.15.255";
        //public static string ip = "http://192.168.43.12:8080";
    }
}
