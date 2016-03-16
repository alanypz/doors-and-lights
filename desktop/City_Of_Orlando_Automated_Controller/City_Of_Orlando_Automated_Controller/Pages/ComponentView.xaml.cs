using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using FirstFloor.ModernUI.Windows.Controls;

namespace City_Of_Orlando_Automated_Controller.Pages
{
    /// <summary>
    /// Interaction logic for ComponentView.xaml
    /// </summary>
    public partial class ComponentView : UserControl
    {
        private Button[] componentButtons = null;

        public ComponentView()
        {
            InitializeComponent();
            initializeDoors();
        }

        void initializeDoors()
        {
            string[] json = null;
            object[] lr = null;

            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/status/door");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:door");
            var serializer = new JavaScriptSerializer();
            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();
                
                lr = serializer.Deserialize<dynamic>(result);
                
                for(int i=0; i<lr.Length; i++)
                {
                    lr[i] = serializer.Serialize(lr[i]);
                }
            }

            Component[] components = new Component[lr.Length];
            componentButtons = new Button[lr.Length];

            //Mach component data
            /*json[0] = "{\"id\":\"0\"," +
                              "\"garage\":\"1\"," +
                              "\"bay\":\"2\"," +
                              "\"status\":\"lowered\"," +
                              "\"lastactiontime\":\"now\"," +
                              "\"lastaction\":\"nothing\"}";
            
            json[1] = "{\"id\":\"1\"," +
                              "\"garage\":\"1\"," +
                              "\"bay\":\"2\"," +
                              "\"status\":\"raised\"," +
                              "\"lastactiontime\":\"now\"," +
                              "\"lastaction\":\"nothing\"}";

            json[2] = "{\"id\":\"0\"," +
                              "\"garage\":\"1\"," +
                              "\"bay\":\"3\"," +
                              "\"status\":\"lowered\"," +
                              "\"lastactiontime\":\"now\"," +
                              "\"lastaction\":\"nothing\"}";

            json[3] = "{\"id\":\"0\"," +
                              "\"garage\":\"1\"," +
                              "\"bay\":\"4\"," +
                              "\"status\":\"lowered\"," +
                              "\"lastactiontime\":\"now\"," +
                              "\"lastaction\":\"nothing\"}";

            json[4] = "{\"id\":\"0\"," +
                              "\"garage\":\"1\"," +
                              "\"bay\":\"5\"," +
                              "\"status\":\"lowered\"," +
                              "\"lastactiontime\":\"now\"," +
                              "\"lastaction\":\"nothing\"}";*/
            
            for(int i=0; i< lr.Length; i++)
            {
                components[i] = serializer.Deserialize<Component>(lr[i].ToString());
                Button newComponent = new Button();
                Thickness margin = newComponent.Margin;
                margin.Left = 5;
                margin.Right = 5;
                margin.Top = 9;
                newComponent.Tag = components[i];
                newComponent.Content = "Component " + (i+1).ToString();
                newComponent.HorizontalAlignment = HorizontalAlignment.Left;
                newComponent.VerticalAlignment = VerticalAlignment.Top;
                newComponent.HorizontalContentAlignment = HorizontalAlignment.Center;
                newComponent.VerticalContentAlignment = VerticalAlignment.Center;
                newComponent.Width = 124;
                newComponent.Height = 30;
                newComponent.Margin = margin;
                newComponent.AddHandler(Button.ClickEvent, new RoutedEventHandler(button_Click));
                componentButtons[i] = newComponent;
                wp.Children.Add(newComponent);
            }

           
        }


        void button_Click(object sender, EventArgs e)
        {
            Button button = sender as Button;

            if (!SelectionMode.IsChecked.Value)
            {
                Component component = (Component)button.Tag;

                string data =

                    "ID: " + component._id + "\n" +
                    "Number:" + component.number.ToString() + "\n" +
                    //"Garage: " + component.garage.ToString() + "\n" +
                    //"Bay: " + component.bay.ToString() + "\n" +
                    "Status: " + component.state + "\n" +
                    "Position: " + component.position
                    //"Last Action Time: " + component.lastActionTime + "\n" +
                    //"Last Action: " + component.lastAction
                ;


                ModernDialog.ShowMessage(data, "Component Status", MessageBoxButton.OK);
            }

            else
            {
                for(int i=0; i<componentButtons.Length; i++)
                {
                    componentButtons[i].ClearValue(BackgroundProperty);
                }

                button.Background = Brushes.PowderBlue;
                CommandButton.IsEnabled = true;
            }
        }

        private void CommandButton_Click(object sender, RoutedEventArgs e)
        {
            Button selectedComponent = null;

            for(int i=0; i<componentButtons.Length; i++)
            {
                if(componentButtons[i].Background == Brushes.PowderBlue)
                {
                    selectedComponent = componentButtons[i];
                }
            }

            Component component = (Component)selectedComponent.Tag;

            string data =

                    "Number: " + component.number.ToString() + "\n" +
                    "Position: " + component.position.ToString() + "\n" +
                    "Status: " + component.state + "\n" 
                ;

            ModernDialog commandView = new CommandView(data);
            commandView.ShowDialog();
        }

        private void SelectionMode_Checked(object sender, RoutedEventArgs e)
        {
            for (int i = 0; i < componentButtons.Length; i++)
            {
                componentButtons[i].ClearValue(BackgroundProperty);
            }
        }

        private void SelectionMode_Unchecked(object sender, RoutedEventArgs e)
        {
            for (int i = 0; i < componentButtons.Length; i++)
            {
                componentButtons[i].ClearValue(BackgroundProperty);
            }

            CommandButton.IsEnabled = false;
        }
    }
}
