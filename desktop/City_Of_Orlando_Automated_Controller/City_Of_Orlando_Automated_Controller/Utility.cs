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
    }
}
